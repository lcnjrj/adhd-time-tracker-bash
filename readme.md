# 🧠 ADHD Time Tracker - Gestão de Tempo Consciente

> Sistema de rastreamento de tarefas para pessoas com ADHD/TDAH que valorizam foco, checkpoints e análise retrospectiva

[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green?style=flat&logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![SQLite](https://img.shields.io/badge/SQLite-3-blue?style=flat&logo=sqlite)](https://www.sqlite.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-8.5-blue)](https://github.com/lcnjrj/adhd-time-tracker-bash)

---

## 📋 Sobre o Projeto

**ADHD Time Tracker** é uma ferramenta CLI desenvolvida especificamente para pessoas com ADHD/TDAH que precisam monitorar tarefas de forma **consciente e intencional**, incluindo atividades offline como leitura de livros físicos, desenho em papel, estudo analógico e trabalho fora do computador.

Diferente de rastreadores automáticos, este sistema permite que você **declare** o que está fazendo, registre níveis de foco e energia, e analise padrões de produtividade ao longo do tempo - tudo com integração direta ao seu calendário (KOrganizer, Google Calendar via arquivos .ics).

### 🎯 Por Que Este Projeto Existe

Como pessoa com ADHD/TOC, eu precisava de uma ferramenta que:
- ✅ **Funcionasse offline** - sem depender de apps mobile que causam distrações
- ✅ **Registrasse atividades analógicas** - leitura física, desenho em papel, estudos offline
- ✅ **Permitisse pausas frequentes** - respeitando ciclos naturais de atenção
- ✅ **Salvasse checkpoints** - crucial para evitar perder contexto em distrações
- ✅ **Oferecesse motivação gentil** - lembretes positivos sem pressão
- ✅ **Gerasse histórico analisável** - para entender meus padrões de produtividade

Não encontrei nada que atendesse essas necessidades, então criei.

---

## ✨ Funcionalidades

### Rastreamento Consciente
- ⏱️ **Monitoramento interativo** - Você declara quando começa uma tarefa
- ⏸️ **Sistema de pausa/retomada** - Pausas ilimitadas sem perder contexto
- 💾 **Checkpoints sob demanda** - Salve progresso a qualquer momento
- 📊 **Cálculo automático** de tempo total e por período

### Análise e Insights
- 🧠 **Registro de foco** (1-10) - Qual foi seu nível de concentração?
- ⚡ **Registro de energia** (1-10) - Como estava sua energia?
- 📂 **Categorização** - Trabalho, estudo, pessoal, criativo, administrativo
- 📈 **Estatísticas automáticas** - Períodos focados, tempo médio, insights ADHD-friendly

### Integração com Calendário
- 📅 **Formato iCalendar (.ics)** - Importável em qualquer aplicativo de calendário
- 🗄️ **Banco SQLite** - Histórico completo queryável para análises
- 📆 **Retrospectiva diária** - Veja todas as tarefas do dia em resumo
- 🔍 **Pesquisa histórica** - Consulte padrões de produtividade

### Interface ADHD-Friendly
- 🎯 **Visual claro** - Informações importantes em destaque
- 💬 **Mensagens motivacionais** - Incentivo positivo durante o trabalho
- 🔔 **Feedback imediato** - Cada ação tem resposta visual
- 📏 **Barra de progresso** - Representação visual do tempo decorrido

---
[![Tela inicial]](https://github.com/lcnjrj/adhd-time-tracker-bash/blob/main/screen-inicial-00.jpg)
---

## 🚀 Instalação

### Pré-requisitos

```bash
# Ferramentas necessárias:
- bash 4.0+
- sqlite3
- date (GNU coreutils)

# Verificar se SQLite está instalado:
sqlite3 --version

# Se não estiver:
sudo apt install sqlite3  # Debian/Ubuntu
sudo dnf install sqlite   # Fedora
```

### Instalação do Script

```bash
# Clone o repositório
git clone https://github.com/lcnjrj/adhd-time-tracker-bash.git
cd adhd-time-tracker-bash

# Tornar executável
chmod +x adhd-retro-calendar-final.v8.5.sh

# (Opcional) Instalar globalmente
sudo cp adhd-retro-calendar-final.v8.5.sh /usr/local/bin/adhd-tracker
```

### Configuração Inicial

O script cria automaticamente a estrutura de diretórios:
```
~/.adhd-tracker/
├── logs/              # Logs de texto de cada tarefa
├── backups/           # Backups automáticos dos logs
└── retrospective/
    ├── productivity.db      # Banco SQLite com histórico
    └── calendar_entries/    # Arquivos .ics para calendário
```

---

## 💻 Uso

### Iniciar Rastreamento

```bash
./adhd-retro-calendar-final.v8.5.sh
```

**O script perguntará:**
1. Nome da tarefa (ex: "Estudar Python - Capítulo 3")
2. Se arquivo já existe: anexar, sobrescrever ou cancelar

**Então você verá:**
```
========================================
🧠 ADHD TIME TRACKER
========================================
Tarefa: Estudar Python - Capítulo 3
Status: ▶️  EM ANDAMENTO
------------------------------------------

    ⏱️  00:15:42

Progresso: [███]
------------------------------------------
Comandos:
  [p] Pausar/Continuar  [f] Finalizar
  [s] Salvar checkpoint [m] Motivar-me!
========================================
```

### Comandos Durante Rastreamento

| Tecla | Ação | Quando Usar |
|-------|------|-------------|
| **p** | Pausar/Continuar | Pausa para banheiro, café, distração inevitável |
| **f** | Finalizar tarefa | Quando completar ou desistir da tarefa |
| **s** | Salvar checkpoint | Antes de uma interrupção planejada |
| **m** | Mensagem motivacional | Quando precisar de encorajamento |

### Após Finalizar

O script coleta metadados para análise retrospectiva:

```
📝 Vamos documentar esta sessão para análise futura:

🧠 Qual foi seu nível de foco? (1-10, 10=máximo): 7
⚡ E seu nível de energia? (1-10): 6

📂 Escolha a categoria:
   1) Trabalho
   2) Estudo
   3) Pessoal
   4) Criativo
   5) Administrativo
   6) Outro
Sua escolha (1-6): 2
```

---

## 🎓 Casos de Uso Reais

### **1. Leitura de Livros Físicos**
```
Tarefa: "Ler 'Clean Code' - Capítulo 4"
Duração: 45 minutos
Foco: 8/10
Categoria: Estudo

✅ Registra no calendário mesmo não estando no computador
✅ Histórico de quanto tempo dedica a leitura
✅ Análise de melhor horário para ler
```

### **2. Desenho e Esquemas em Papel**
```
Tarefa: "Desenhar arquitetura do sistema X"
Duração: 1h30 com 2 pausas
Foco: 9/10 (hiperfoco detectado!)
Categoria: Criativo

✅ Rastreia atividades criativas analógicas
✅ Checkpoints salvos durante o processo
✅ Barra de progresso visual para manter noção de tempo
```

### **3. Estudo com Material Físico**
```
Tarefa: "Estudar matemática - exercícios caderno"
Duração: 2h15 com 4 pausas (ADHD-friendly!)
Foco: 6/10 (variável, mas produtivo)
Categoria: Estudo

✅ Pausas frequentes sem perder contexto
✅ Motivação entre períodos
✅ Estatística mostra média de 30min por período focado
```

### **4. Trabalho Offline (Presencial)**
```
Tarefa: "Reunião presencial - planejamento trimestre"
Duração: 1h exata
Foco: 7/10
Categoria: Trabalho

✅ Registra atividades fora do computador
✅ Integra ao calendário retrospectivamente
✅ Mantém histórico completo de tempo trabalhado
```

---

## 📊 Integração com Calendário

### Arquivo .ics Gerado

Cada tarefa gera um arquivo `.ics` compatível com qualquer aplicativo de calendário:

```
~/.adhd-tracker/retrospective/calendar_entries/
└── 20241208_143022_Estudar_Python_Capítulo_3.ics
```

**Conteúdo:**
```ics
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//ADHD Tracker//Retrospective Logging
BEGIN:VEVENT
DTSTAMP:20241208T143022Z
DTSTART:20241208T140000
DTEND:20241208T151500
SUMMARY:[ADHD] Estudar Python - Capítulo 3
DESCRIPTION:Duração: 90 minutos\nFoco: 8/10\nEnergia: 7/10\nCategoria: estudo
CATEGORIES:ADHD,estudo
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR
```

### Importar no KOrganizer (Linux)

```bash
# Importar arquivo único
korganizer ~/.adhd-tracker/retrospective/calendar_entries/20241208_143022_*.ics

# Ou importar todos de uma vez
cat ~/.adhd-tracker/retrospective/calendar_entries/*.ics > todas_tarefas.ics
korganizer todas_tarefas.ics
```

### Importar no Google Calendar

1. Acesse Google Calendar no navegador
2. Configurações → Importar e exportar
3. Selecionar arquivo → Escolher `.ics`
4. Importar para calendário desejado

---

## 🗄️ Banco de Dados SQLite

### Estrutura da Tabela

```sql
CREATE TABLE tarefas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data TEXT NOT NULL,
    hora_inicio TEXT NOT NULL,
    duracao_minutos INTEGER NOT NULL,
    tarefa TEXT NOT NULL,
    categoria TEXT NOT NULL,
    foco INTEGER CHECK(foco >= 1 AND foco <= 10),
    energia INTEGER CHECK(energia >= 1 AND energia <= 10)
);
```

### Consultas Úteis

**Ver todas as tarefas de hoje:**
```bash
sqlite3 ~/.adhd-tracker/retrospective/productivity.db \
  "SELECT * FROM tarefas WHERE data = date('now');"
```

**Tarefas com foco alto (8+):**
```bash
sqlite3 ~/.adhd-tracker/retrospective/productivity.db \
  "SELECT tarefa, foco, duracao_minutos FROM tarefas WHERE foco >= 8 ORDER BY foco DESC;"
```

**Total de horas por categoria (última semana):**
```bash
sqlite3 ~/.adhd-tracker/retrospective/productivity.db \
  "SELECT categoria, ROUND(SUM(duracao_minutos)/60.0, 2) as horas
   FROM tarefas
   WHERE data >= date('now', '-7 days')
   GROUP BY categoria
   ORDER BY horas DESC;"
```

**Média de foco por horário do dia:**
```bash
sqlite3 ~/.adhd-tracker/retrospective/productivity.db \
  "SELECT substr(hora_inicio, 1, 2) as hora, ROUND(AVG(foco), 1) as foco_medio
   FROM tarefas
   GROUP BY hora
   ORDER BY hora;"
```

---

## 🎯 Insights Automáticos ADHD-Friendly

O script detecta automaticamente padrões e oferece feedback:

### Tarefa Curta (< 15min)
```
💡 Insight: Tarefa curta - ideal para TDAH!
```
*Sessões curtas são perfeitas para manter engajamento.*

### Hiperfoco Detectado (> 2h contínuas)
```
💡 Insight: Hiperfoco detectado! Lembre-se de descansar.
```
*Importante lembrar de pausas mesmo durante hiperfoco.*

### Múltiplos Períodos Focados
```
🎯 Você fez 4 períodos focados!
   Isso é excelente para gestão de energia com TDAH.
```
*Validação de que períodos curtos são estratégia eficaz.*

---

## 💬 Mensagens Motivacionais

Durante o trabalho, pressionar `m` exibe mensagens de incentivo:

```
✨ 🎯 Você está indo bem! Pequenos passos levam longe.
✨ 🧠 Hiperfoco ativado! Aproveite esta energia.
✨ ⏱️  Cada minuto conta. Continue assim!
✨ 💡 Se distraiu? Sem problemas. Volte quando puder.
✨ 🚀 Progresso, não perfeição. Você está no caminho!
✨ 🔄 TDAH é um superpoder quando direcionado. Você consegue!
```

Todas as mensagens são salvas no log com timestamp para revisão posterior.

---

## 📁 Formato do Log em Texto

Cada tarefa gera um arquivo detalhado em `~/.adhd-tracker/logs/`:

```
🧠 ADHD TIME TRACKER - LOG
==========================
Tarefa: Estudar Python - Capítulo 3
Início: Sáb Dez  8 14:00:00 -03 2024
Uptime: up 2 hours, 15 minutes
Sistema: Linux 6.5.0-14-generic x86_64
Usuário: usuario
==========================

Checkpoint 14:25:30: 00:25:30
Motivação 14:30:15: 🚀 Progresso, não perfeição. Você está no caminho!
---
⏸️  Pausado em: Sáb Dez  8 14:35:00 -03 2024
Tempo até pausa: 00:35:00
▶️  Retomado em: Sáb Dez  8 14:42:00 -03 2024
Pausa durou: 00:07:00
---
Checkpoint 15:00:00: 00:53:00

==========================
🏁 FINALIZADO
Fim: Sáb Dez  8 15:15:00 -03 2024
Tempo Total: 01:08:00

📊 RESUMO DOS PERÍODOS:
Período 1: 00:35:00
Período 2: 00:33:00

📈 ESTATÍSTICAS:
- Períodos trabalhados: 2
- Média por período: 00:34:00
💡 Insight: Tarefa média - boa gestão de pausas para TDAH!
==========================
```

---

## 🛠️ Implementação Técnica

### Arquitetura do Código

```
adhd-retro-calendar-final.v8.5.sh
├── Configuração
│   ├── Diretórios e caminhos
│   └── Estrutura de dados (SQLite)
├── Funções de Calendário
│   ├── criar_evento_retrospectivo()
│   ├── adicionar_ao_banco()
│   ├── registrar_tarefa_calendario()
│   └── mostrar_resumo_dia()
├── Funções Auxiliares
│   ├── formata_tempo()
│   ├── mostra_tempo_decorrido()
│   ├── salva_checkpoint()
│   └── motivacao_adhd()
├── Loop Principal
│   ├── Captura de teclas não-bloqueante
│   ├── Atualização de interface em tempo real
│   └── Sistema de estados (rodando/pausado)
└── Finalização
    ├── Cálculo de estatísticas
    ├── Coleta de metadados
    └── Geração de arquivos (.ics + SQLite)
```

### Tecnologias Utilizadas

- **Bash 4.0+** - Linguagem principal
- **SQLite3** - Persistência estruturada de dados
- **iCalendar (RFC 5545)** - Formato padrão de calendário
- **GNU date** - Manipulação de datas e timestamps
- **GNU coreutils** - Ferramentas Unix padrão

### Principais Desafios Técnicos Resolvidos

1. ✅ **Cálculo preciso de tempo com múltiplas pausas**
   - Acumula períodos independentemente
   - Não perde precisão em pausas longas

2. ✅ **Interface interativa não-bloqueante**
   - Atualização em tempo real (1 segundo)
   - Captura de teclas com `read -t 1 -n 1 -s`

3. ✅ **Geração de .ics válidos**
   - Formato RFC 5545 completo
   - Timezones e UTC corretamente calculados

4. ✅ **Integração SQLite em Bash**
   - Criação de tabelas com constraints
   - Queries estruturadas e seguras

5. ✅ **Sanitização de entrada**
   - Remove caracteres problemáticos para filesystem
   - Validação de entrada em loops

---

## 🎓 Principais Aprendizados

Desenvolver e **usar diariamente** este projeto me ensinou:

- ✅ **Shell scripting avançado** - Estados, loops não-bloqueantes, funções modulares
- ✅ **Integração SQL em Bash** - SQLite como backend estruturado
- ✅ **Padrões de dados** - iCalendar RFC 5545, formato de evento
- ✅ **UX para necessidades especiais** - Interface ADHD-friendly, feedback constante
- ✅ **Persistência de dados** - Múltiplos formatos (texto, SQL, ICS)
- ✅ **Design de produto** - Resolver problema real
- ✅ **Documentação técnica** - Logs detalhados, estatísticas compreensíveis

---

## 🌟 Diferencial Deste Projeto

### **Vs. Apps Mobile de Time Tracking**

| Aspecto | Apps Mobile | ADHD Time Tracker |
|---------|-------------|-------------------|
| Distrações | ❌ Notificações, redes sociais | ✅ Terminal focado |
| Offline | ⚠️ Limitado | ✅ 100% offline |
| Atividades analógicas | ❌ Não rastreia | ✅ Registra livros, desenho |
| Pausas | ⚠️ Desencoraja | ✅ ADHD-friendly, ilimitadas |
| Privacidade | ❌ Cloud, telemetria | ✅ Dados locais, seu controle |
| Custo | 💰 Assinatura mensal | ✅ Gratuito, open-source |

### **Vs. Rastreadores Automáticos**

| Aspecto | Rastreadores Automáticos | ADHD Time Tracker |
|---------|-------------------------|-------------------|
| Atividades offline | ❌ Não detecta | ✅ Você declara |
| Intenção vs execução | ❌ Só execução | ✅ Intencional |
| Leitura/desenho | ❌ Não rastreia | ✅ Registra perfeitamente |
| Controle | ⚠️ Passivo | ✅ Ativo e consciente |

---

## 🐛 Limitações Conhecidas

### Atuais
- Não é um daemon - requer execução manual para cada tarefa
- Interface CLI apenas (sem GUI)
- Sem sincronização entre dispositivos
- Sem notificações desktop automáticas

### Por Design (não são bugs!)
- **Rastreamento manual é intencional** - Promove consciência da tarefa
- **Terminal é proposital** - Evita distrações de apps gráficos
- **Sem automação** - Você decide quando rastrear

---

## 🚀 Roadmap (Futuro Potencial)

**Nota:** Atualmente o script atende perfeitamente minhas necessidades. Melhorias futuras dependerão de uso e feedback da comunidade.

Possibilidades exploradas pela comunidade:
- [ ] Modo daemon (iniciar/parar tarefas via comandos rápidos)
- [ ] Integração com notify-send (notificações desktop)
- [ ] Dashboard web simples (visualização de dados SQLite)
- [ ] Export para formatos adicionais (CSV, JSON, Markdown)
- [ ] Gráficos ASCII de produtividade semanal
- [ ] Integração com Pomodoro Technique

---

## 🤝 Contribuindo

Este projeto nasceu de necessidade pessoal e é **usado diariamente**. Contribuições são bem-vindas se:

- Respeitarem o design ADHD-friendly (pausas, checkpoints, motivação)
- Mantiverem funcionamento 100% offline
- Não adicionarem dependências desnecessárias
- Forem testadas em ambiente real de uso

### Como Contribuir

1. Fork o projeto
2. Teste extensivamente (idealmente por 1 semana de uso real)
3. Documente mudanças claramente
4. Abra Pull Request explicando o benefício

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👤 Autora

**Luciana J de Faria** - Administradora de Sistemas Linux | ADHD/OCD | Entusiasta de Produtividade

Este script existe porque eu **precisava** dele. Como pessoa com ADHD que trabalha com tecnologia, passar horas na frente do computador pode ser produtivo ou totalmente dispersivo.

Mas minha produtividade não acontece só na tela - leio livros técnicos em papel, desenho arquiteturas em cadernos, faço esquemas à mão. Nenhuma ferramenta de time tracking considerava essas atividades "invisíveis" ao computador.

Então criei minha própria ferramenta. E uso ela todos os dias desde 2021.

Se você também tem ADHD, trabalha com atividades mistas (digital + analógico), e quer **consciência** do seu tempo sem depender de apps que te distraem - essa ferramenta é para você.

### Conecte-se Comigo
- 💼 **GitHub:** [@lcnjrj](https://github.com/lcnjrj)
---

## 🙏 Agradecimentos

- **Comunidade ADHD/TDAH** - Por compartilhar experiências e desafios
- **Projeto SQLite** - Por um banco de dados leve e confiável
- **iCalendar RFC 5545** - Por um padrão aberto de calendário
- **Meu ADHD** - Por me forçar a criar ferramentas melhores 😊

---

## 📈 Estatísticas do Projeto

- **Versão atual:** 8.5 (evoluindo desde 2021)
- **Linhas de código:** ~300
- **Dependências:** 1 (SQLite3)
- **Uso pessoal:** Diário desde criação
- **Tarefas registradas:** 2300+ (estimativa pessoal)
- **Testado em:** Lubuntu 22.04, Ubuntu 24.04, Debian 11

---

## 🔗 Projetos Relacionados

### Da mesma autora

- [Disk Analyzer](https://github.com/lcnjrj/disk-analyzer-bash) - Análise de uso de disco

---

⭐ **Se esta ferramenta ajuda sua produtividade, considere dar uma estrela!** ⭐
🧠 **Tem ADHD/TDAH? Experimente e compartilhe sua experiência!**
🤝 **Melhorias? Abra uma issue ou PR!**

---

*"ADHD não é déficit de atenção. É atenção em todas as direções. Esta ferramenta me ajuda a direcionar essa energia."*

---

## 📚 Recursos sobre ADHD e Produtividade

- [Como o ADHD afeta gestão de tempo](https://www.additudemag.com/time-management-for-adults-with-adhd/)
- [Estratégias de produtividade para ADHD](https://www.understood.org/en/articles/productivity-strategies-for-adults-with-adhd)
- [Por que ferramentas offline funcionam melhor](https://www.psychologytoday.com/us/blog/technology-and-the-mind/201806/why-paper-to-do-lists-are-more-effective-than-digital-ones)
