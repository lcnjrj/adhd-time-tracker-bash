#!/bin/bash
VERSION="8.5"
# 🧠 ADHD Time Tracker v8.5 - Com Calendário Retrospectivo
# Autor: Luciana Faria 2021 / AI 2025
#Para estudantes que se perdem, ou não se adptam em monitorar pelo smartphone pois acabam abrindo #algum outro app
# Monitoramento de tarefas (incluindo offline/impressas para estudantes)

# ===== CONFIGURAÇÃO =====
# não precisa ser pasta oculta, para torna-la visivel retire o ponto antes de adhd nas três linh abaixo
LOG_DIR="$HOME/.adhd-tracker/logs"
BACKUP_DIR="$HOME/.adhd-tracker/backups"
RETRO_DIR="$HOME/.adhd-tracker/retrospective"
PRODUCTIVITY_DB="$RETRO_DIR/productivity.db"
CALENDAR_LOGS="$RETRO_DIR/calendar_entries"

# Criar estrutura de diretórios
mkdir -p "$LOG_DIR" "$BACKUP_DIR" "$RETRO_DIR" "$CALENDAR_LOGS"

# ===== FUNÇÕES DE CALENDÁRIO RETROSPECTIVO (NOVAS) =====

criar_evento_retrospectivo() {
    local tarefa="$1"
    local data_inicio="$2"
    local duracao="$3"
    local energia="$4"
    local foco="$5"
    local categoria="$6"

    # Tenta converter a data, se falhar usa agora
    local inicio_iso
    inicio_iso=$(date -d "$data_inicio" +"%Y%m%dT%H%M00" 2>/dev/null)
    if [ $? -ne 0 ]; then
        inicio_iso=$(date +"%Y%m%dT%H%M00")
    fi

    local fim_iso
    fim_iso=$(date -d "$data_inicio $duracao minutes" +"%Y%m%dT%H%M00" 2>/dev/null)
    if [ $? -ne 0 ]; then
        fim_iso=$(date -d "$duracao minutes" +"%Y%m%dT%H%M00")
    fi

    cat << ICS
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//ADHD Tracker//Retrospective Logging
BEGIN:VEVENT
UID:adhd-$(date +%s)-$RANDOM
DTSTAMP:$(date -u +%Y%m%dT%H%M%SZ)
DTSTART:${inicio_iso}
DTEND:${fim_iso}
SUMMARY:[ADHD] ${tarefa}
DESCRIPTION:Duração: ${duracao} minutos\\nFoco: ${foco}/10\\nEnergia: ${energia}/10\\nCategoria: ${categoria}
CATEGORIES:ADHD,${categoria}
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR
ICS
}

adicionar_ao_banco() {
    local tarefa="$1"
    local data_inicio="$2"
    local duracao="$3"
    local energia="$4"
    local foco="$5"
    local categoria="$6"

    # Cria banco se não existir
    if [ ! -f "$PRODUCTIVITY_DB" ]; then
        sqlite3 "$PRODUCTIVITY_DB" << 'SQL'
CREATE TABLE IF NOT EXISTS tarefas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data TEXT NOT NULL,
    hora_inicio TEXT NOT NULL,
    duracao_minutos INTEGER NOT NULL,
    tarefa TEXT NOT NULL,
    categoria TEXT NOT NULL,
    foco INTEGER CHECK(foco >= 1 AND foco <= 10),
    energia INTEGER CHECK(energia >= 1 AND energia <= 10)
);
SQL
    fi

    local data hora
    # Extrai data e hora da string
    data=$(echo "$data_inicio" | awk '{print $1}')
    hora=$(echo "$data_inicio" | awk '{print $2}')

    if [ -z "$data" ]; then
        data=$(date +"%Y-%m-%d")
        hora=$(date +"%H:%M")
    fi

    # Se hora estiver vazia
    if [ -z "$hora" ]; then
        hora=$(date +"%H:%M")
    fi

    sqlite3 "$PRODUCTIVITY_DB" << SQL
INSERT INTO tarefas (data, hora_inicio, duracao_minutos, tarefa, categoria, foco, energia)
VALUES ('$data', '$hora', $duracao, '$tarefa', '$categoria', $foco, $energia);
SQL
}

registrar_tarefa_calendario() {
    local tarefa="$1"
    local data_inicio="$2"
    local duracao_minutos="$3"
    local energia="$4"
    local foco="$5"
    local categoria="$6"

    echo "📊 Registrando tarefa para análise histórica..."

    # Cria arquivo ICS
    local nome_arquivo_safe
    nome_arquivo_safe=$(echo "$tarefa" | tr ' ' '_' | tr '/' '_' | tr '\\' '_' | tr -d '*?:<>|"')
    local arquivo_ics="$CALENDAR_LOGS/$(date +%Y%m%d_%H%M%S)_${nome_arquivo_safe}.ics"

    criar_evento_retrospectivo "$tarefa" "$data_inicio" "$duracao_minutos" "$energia" "$foco" "$categoria" > "$arquivo_ics"

    # Adiciona ao banco
    adicionar_ao_banco "$tarefa" "$data_inicio" "$duracao_minutos" "$energia" "$foco" "$categoria"

    echo "✅ Registro histórico completo!"
    echo "   📁 ICS: $arquivo_ics"
    echo "   📊 Banco: $PRODUCTIVITY_DB"
}

integrar_calendario_pos_tarefa() {
    local nome_tarefa="$1"
    local data_inicio="$2"
    local tempo_total_segundos="$3"

    echo ""
    echo "=========================================="
    echo "   📅 REGISTRO HISTÓRICO DA TAREFA        "
    echo "=========================================="
    echo ""

    local duracao_minutos=$((tempo_total_segundos / 60))

    # Coleta metadados
    echo "📝 Vamos documentar esta sessão para análise futura:"
    echo ""

    # Nível de foco
    local foco
    while true; do
        read -p "🧠 Qual foi seu nível de foco? (1-10, 10=máximo): " foco
        if [[ "$foco" =~ ^[0-9]+$ ]] && [ "$foco" -ge 1 ] && [ "$foco" -le 10 ]; then
            break
        fi
        echo "⚠️  Por favor, insira um número entre 1 e 10"
    done

    # Nível de energia
    local energia
    while true; do
        read -p "⚡ E seu nível de energia? (1-10): " energia
        if [[ "$energia" =~ ^[0-9]+$ ]] && [ "$energia" -ge 1 ] && [ "$energia" -le 10 ]; then
            break
        fi
        echo "⚠️  Por favor, insira um número entre 1 e 10"
    done

    # Categoria
    echo ""
    echo "📂 Escolha a categoria:"
    echo "   1) Trabalho"
    echo "   2) Estudo"
    echo "   3) Pessoal"
    echo "   4) Criativo"
    echo "   5) Administrativo"
    echo "   6) Outro"
    read -p "Sua escolha (1-6): " categoria_num

    local categoria
    case "$categoria_num" in
        1) categoria="trabalho" ;;
        2) categoria="estudo" ;;
        3) categoria="pessoal" ;;
        4) categoria="criativo" ;;
        5) categoria="administrativo" ;;
        *) categoria="outro" ;;
    esac

    # Registra
    registrar_tarefa_calendario "$nome_tarefa" "$data_inicio" "$duracao_minutos" "$energia" "$foco" "$categoria"

    # Mostra estatística rápida
    echo ""
    echo "📈 Estatística desta sessão:"
    echo "   ⏱️  Duração: $duracao_minutos minutos"
    echo "   🧠 Foco: $foco/10"
    echo "   ⚡ Energia: $energia/10"
    echo "   📂 Categoria: $categoria"

    # Pergunta se quer ver o dia
    echo ""
    read -p "🔍 Ver resumo do dia? [s/N] " ver_dia
    if [[ "$ver_dia" =~ ^[Ss]$ ]]; then
        mostrar_resumo_dia "$data_inicio"
    fi
}

mostrar_resumo_dia() {
    local data="$1"
    local data_sql

    # Extrai apenas a data (YYYY-MM-DD)
    if [[ "$data" == *" "* ]]; then
        data_sql=$(echo "$data" | awk '{print $1}')
    else
        data_sql="$data"
    fi

    if [ -z "$data_sql" ]; then
        data_sql=$(date +"%Y-%m-%d")
    fi

    echo ""
    echo "📅 RESUMO DO DIA: $data_sql"
    echo "=========================================="

    if [ ! -f "$PRODUCTIVITY_DB" ]; then
        echo "📭 Nenhum dado histórico ainda"
        return
    fi

    # Busca tarefas do dia
    sqlite3 "$PRODUCTIVITY_DB" << SQL | while IFS='|' read -r hora tarefa duracao categoria foco; do
SELECT
    hora_inicio,
    substr(tarefa, 1, 25),
    duracao_minutos,
    categoria,
    foco
FROM tarefas
WHERE data = '$data_sql'
ORDER BY hora_inicio;
SQL
        echo "  $hora - $tarefa"
        echo "      ⏱️  ${duracao}min | 🧠 ${foco}/10 | 📂 $categoria"
        echo ""
    done

    # Total do dia
    local total_info
    total_info=$(sqlite3 "$PRODUCTIVITY_DB" << SQL
SELECT
    COUNT(*) || ' tarefas, ' ||
    SUM(duracao_minutos) || ' minutos (' ||
    ROUND(SUM(duracao_minutos)/60.0, 1) || ' horas)'
FROM tarefas
WHERE data = '$data_sql';
SQL
    )

    if [ -n "$total_info" ]; then
        echo "📊 Total do dia: $total_info"
    else
        echo "📊 Nenhuma tarefa registrada neste dia"
    fi
}

# ===== FUNÇÕES AUXILIARES (DO SEU SCRIPT ORIGINAL) =====

# Formata tempo em HH:MM:SS
formata_tempo() {
  local segundos=$1
  local horas=$((segundos / 3600))
  local minutos=$(( (segundos % 3600) / 60 ))
  local segundos=$((segundos % 60))
  printf "%02d:%02d:%02d" "$horas" "$minutos" "$segundos"
}

# Mostra tempo decorrido em tempo real (SEU VISUAL ORIGINAL)
mostra_tempo_decorrido() {
  local inicio=$1
  local pausado=$2
  local tempo_pausa=$3
  local tempo_total_anterior=$4

  clear
  echo "=========================================="
  echo "🧠 ADHD TIME TRACKER"
  echo "=========================================="
  echo "Tarefa: $nome_tarefa"
  echo "Status: $([ "$pausado" -eq 1 ] && echo "⏸️  PAUSADO" || echo "▶️  EM ANDAMENTO")"
  echo "------------------------------------------"

  if [ "$pausado" -eq 1 ]; then
    local tempo_decorrido=$((tempo_total_anterior))
  else
    local agora=$(date +%s)
    local tempo_decorrido=$((tempo_total_anterior + agora - inicio))
  fi

  # Mostra tempo grande (visualmente claro)
  echo ""
  echo "    ⏱️  $(formata_tempo "$tempo_decorrido")"
  echo ""

  # Barra de progresso visual (cada 30min = 1 caractere)
  local horas_decorridas=$((tempo_decorrido / 1800))  # 30 minutos
  local progresso=""
  for ((i=0; i<horas_decorridas && i<20; i++)); do
    progresso="${progresso}█"
  done
  echo "Progresso: [$progresso]"
  echo "------------------------------------------"

  # Comandos disponíveis
  echo "Comandos:"
  echo "  [p] Pausar/Continuar  [f] Finalizar"
  echo "  [s] Salvar checkpoint [m] Motivar-me!"
  echo "=========================================="
}

# Salva checkpoint (útil para TDAH) - SEU ORIGINAL
salva_checkpoint() {
  local checkpoint_temp=$(date +%s)
  local tempo_decorrido=$((tempo_total + checkpoint_temp - tempo_inicio))

  echo "Checkpoint $(date '+%H:%M:%S'): $(formata_tempo "$tempo_decorrido")" >> "$nome_arquivo"
  echo "💾 Checkpoint salvo!"
  sleep 1
}

# Função motivacional aleatória - SEU ORIGINAL
motivacao_adhd() {
  local mensagens=(
    "🎯 Você está indo bem! Pequenos passos levam longe."
    "🧠 Hiperfoco ativado! Aproveite esta energia."
    "⏱️  Cada minuto conta. Continue assim!"
    "💡 Se distraiu? Sem problemas. Volte quando puder."
    "🚀 Progresso, não perfeição. Você está no caminho!"
    "🔄 TDAH é um superpoder quando direcionado. Você consegue!"
  )

  local idx=$((RANDOM % ${#mensagens[@]}))
  echo "✨ ${mensagens[$idx]}"
  echo "Motivação $(date '+%H:%M:%S'): ${mensagens[$idx]}" >> "$nome_arquivo"
}

# Backup automático - SEU ORIGINAL
faz_backup() {
  cp "$nome_arquivo" "$BACKUP_DIR/${nome_tarefa}_backup_$(date +%Y%m%d_%H%M%S).txt"
}

# ===== VALIDAÇÃO DA ENTRADA (SEU ORIGINAL) =====
while true; do
  read -p "🧠 Digite o nome da tarefa (ou 'sair' para cancelar): " nome_tarefa

  if [[ "$nome_tarefa" == "sair" ]]; then
    echo "Operação cancelada."
    exit 0
  fi

  if [[ -z "$nome_tarefa" ]]; then
    echo "⚠️  Nome da tarefa não pode ser vazio!"
    continue
  fi

  # Remove caracteres problemáticos para nome de arquivo
  nome_tarefa_limpo=$(echo "$nome_tarefa" | tr -d '/\\:*?"<>|')

  if [[ "$nome_tarefa" != "$nome_tarefa_limpo" ]]; then
    echo "⚠️  Nome ajustado para: $nome_tarefa_limpo"
    nome_tarefa="$nome_tarefa_limpo"
  fi

  nome_arquivo="$LOG_DIR/$nome_tarefa.txt"

  if [[ -f "$nome_arquivo" ]]; then
    read -p "📁 Arquivo já existe. Deseja: [a] anexar, [s] sobrescrever, [c] cancelar? " escolha
    case $escolha in
      a) echo "📝 Anexando ao arquivo existente..." ;;
      s) echo "🔄 Sobrescrevendo arquivo..." > "$nome_arquivo" ;;
      c) continue ;;
      *) echo "⚠️  Opção inválida, cancelando."; continue ;;
    esac
  fi

  break
done

# ===== INICIALIZAÇÃO (SEU ORIGINAL) =====
clear
echo "🚀 Iniciando monitoramento para: $nome_tarefa"
echo "Pressione qualquer tecla para começar..."
read -n 1 -s

data_inicio=$(date)
data_inicio_simples=$(date "+%Y-%m-%d %H:%M")
uptime=$(uptime -p)
tempo_inicio=$(date +%s)
tempo_pausado=0
tempo_total=0
tempo_pausa=0
tempos_parciais=()

# Registra informações iniciais (SEU FORMATO ORIGINAL)
{
  echo "🧠 ADHD TIME TRACKER - LOG"
  echo "=========================="
  echo "Tarefa: $nome_tarefa"
  echo "Início: $data_inicio"
  echo "Uptime: $uptime"
  echo "Sistema: $(uname -srm)"
  echo "Usuário: $(whoami)"
  echo "=========================="
  echo ""
} >> "$nome_arquivo"

# Faz backup inicial
faz_backup

# ===== LOOP PRINCIPAL (SEU ORIGINAL) =====
echo "⏱️  Monitoramento iniciado! Use: p=pausar, f=finalizar, s=checkpoint, m=motivação"
sleep 2

while true; do
  # Mostra tempo decorrido em tempo real
  mostra_tempo_decorrido "$tempo_inicio" "$tempo_pausado" "$tempo_pausa" "$tempo_total"

  # Lê tecla com timeout (atualiza a tela a cada segundo)
  read -t 1 -n 1 -s tecla || continue

  case $tecla in
    p|P)  # Pausar/Continuar
      if [[ "$tempo_pausado" -eq 0 ]]; then  # Pausa
        tempo_pausa=$(date +%s)
        {
          echo "---"
          echo "⏸️  Pausado em: $(date)"
          echo "Tempo até pausa: $(formata_tempo "$((tempo_total + tempo_pausa - tempo_inicio))")"
        } >> "$nome_arquivo"
        tempo_pausado=1
        echo "⏸️  PAUSADO - Descanse ou faça algo diferente!"
      else  # Continua
        tempo_continua=$(date +%s)
        local tempo_parcial=$((tempo_continua - tempo_pausa))
        tempo_total=$((tempo_total + tempo_parcial))
        tempos_parciais+=("$tempo_parcial")

        {
          echo "▶️  Retomado em: $(date)"
          echo "Pausa durou: $(formata_tempo "$tempo_parcial")"
          echo "---"
        } >> "$nome_arquivo"

        tempo_pausado=0
        tempo_pausa=0
        echo "▶️  RETOMADO - Vamos continuar!"
      fi
      ;;

    f|F)  # Finalizar
      tempo_fim=$(date +%s)

      # Calcula tempo final
      if [[ "$tempo_pausado" -eq 0 ]]; then
        local tempo_final_parcial=$((tempo_fim - tempo_inicio - tempo_total))
        tempo_total=$((tempo_total + tempo_final_parcial))
        tempos_parciais+=("$tempo_final_parcial")
      fi

      # Registra finalização (SEU FORMATO ORIGINAL)
      {
        echo ""
        echo "=========================="
        echo "🏁 FINALIZADO"
        echo "Fim: $(date)"
        echo "Tempo Total: $(formata_tempo "$tempo_total")"
        echo ""
        echo "📊 RESUMO DOS PERÍODOS:"
        for i in "${!tempos_parciais[@]}"; do
          echo "Período $((i+1)): $(formata_tempo "${tempos_parciais[$i]}")"
        done
        echo ""
        echo "📈 ESTATÍSTICAS:"
        echo "- Períodos trabalhados: ${#tempos_parciais[@]}"
        echo "- Média por período: $(formata_tempo "$((tempo_total / ${#tempos_parciais[@]}))")"

        if [[ "$tempo_total" -lt 900 ]]; then
          echo "💡 Insight: Tarefa curta - ideal para TDAH!"
        elif [[ "$tempo_total" -gt 7200 ]]; then
          echo "💡 Insight: Hiperfoco detectado! Lembre-se de descansar."
        fi

        echo "=========================="
      } >> "$nome_arquivo"

      # Backup final
      faz_backup

      clear
      echo "✅ Tarefa '$nome_tarefa' finalizada!"
      echo "⏱️  Tempo total: $(formata_tempo "$tempo_total")"
      echo "📄 Log salvo em: $nome_arquivo"
      echo ""

      # Sugestão ADHD-friendly (SEU ORIGINAL)
      if [[ ${#tempos_parciais[@]} -ge 3 ]]; then
        echo "🎯 Você fez ${#tempos_parciais[@]} períodos focados!"
        echo "   Isso é excelente para gestão de energia com TDAH."
      fi

      # NOVA FUNCIONALIDADE: Pergunta sobre registro histórico
      echo ""
      read -p "📅 Registrar tarefa concluída para análise histórica? [S/n] " registrar

      if [[ ! "$registrar" =~ ^[Nn]$ ]]; then
        integrar_calendario_pos_tarefa "$nome_tarefa" "$data_inicio_simples" "$tempo_total"
      fi

      # Abre o arquivo de log (SEU ORIGINAL)
      read -p "📖 Deseja ver o log completo? [s/N] " ver_log
      if [[ "$ver_log" =~ ^[Ss]$ ]]; then
        cat "$nome_arquivo"
      fi

      exit 0
      ;;

    s|S)  # Checkpoint
      salva_checkpoint
      ;;

    m|M)  # Motivação
      motivacao_adhd
      sleep 2
      ;;
  esac
done
