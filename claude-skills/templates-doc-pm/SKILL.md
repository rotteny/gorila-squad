---
name: templates-doc-pm
description: Templates de documentação de produto e processo: PRD, RFC, ADR, além de configuração de ClickUp para squads pequenos e feature flags para separar deploy de release. Carregue na hora de efetivamente escrever um desses documentos ou desenhar o board.
user-invocable: false
---

# Templates de Documentação e Processo


**PRD (Product Requirements Document)** — o quê e por quê:
```
# [Nome da Feature]
## Problema / Oportunidade
## Usuários Afetados e Jobs-to-be-Done
## Solução Proposta (esboço, não spec técnica)
## Métricas de Sucesso
## Fora de Escopo (explícito)
## Critérios de Aceite
```

**RFC (Request for Comments)** — decisões técnicas que precisam de alinhamento:
```
# RFC-NNN: [Título]
## Contexto e Problema
## Opções Consideradas (mín. 2)
## Decisão Proposta e Justificativa
## Trade-offs e Riscos
## Prazo para feedback: [data]
```

**ADR (Architecture Decision Record)** — registra decisão já tomada (imutável):
```
# ADR-NNN: [Título]
## Status: Accepted | Superseded by ADR-XXX
## Contexto
## Decisão
## Consequências
```
Regra: RFC coleta feedback → gera ADR(s) que documentam o resultado. ADRs ficam no repositório (`/docs/adr/`).

### ClickUp para Squads Pequenos (< 15 pessoas)

**Hierarquia recomendada:**
- **Space** = Produto ou área (ex: "TikBot", "Plataforma")
- **Folder** = Épico ou Sprint (ex: "Sprint 12", "Módulo Agendamentos")
- **List** = Tipo de trabalho (Backlog, In Progress, Done) ou feature
- **Task** = Entregável concreto com assignee, prazo e custom fields
- **Subtask** = Apenas quando há dependência sequencial real

**Custom fields essenciais:** Tipo (Bug/Feature/Chore), Estimativa (T-shirt), Sprint, Link PR/commit.

**Automações úteis:** mover task para "In Review" ao abrir PR (via webhook GitHub), notificar no Slack ao mudar status para "Bloqueado", criar task de retrospectiva ao fechar Sprint Folder.

**Linear como alternativa:** preferir para times < 50 devs — 4× mais rápido que Jira no fluxo diário (2.4s vs 9.1s por operação), Triage nativo evita backlog inflado, Cycles automatizam rollover de tarefas não concluídas.

### Feature Flags — Separar Deploy de Release

**Princípio:** código entra em produção desligado → liga progressivamente sem novo deploy.

**Rollout padrão:** 1% → 10% → 50% → 100%, com métricas de erro monitoradas em cada etapa.

**Ferramentas:**
- **LaunchDarkly:** líder de mercado, melhor para enterprise, experimentação A/B robusta.
- **Flagsmith:** open-source, self-hosted, ideal para times < 50 com restrição de custo.

**Governança obrigatória:** toda flag de release recebe data de expiração no momento da criação. Política de sunset: 30 dias após 100% rollout. Máximo 30 flags ativas simultâneas em squads pequenos. Flag debt é dívida técnica real — incluir limpeza de flags na Definition of Done.
