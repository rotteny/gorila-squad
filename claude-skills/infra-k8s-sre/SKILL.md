---
name: infra-k8s-sre
description: Referência de Kubernetes moderno, observabilidade com stack LGTM (Loki/Grafana/Tempo/Mimir), IaC (Terraform/Pulumi/OpenTofu) e SRE — SLI/SLO/SLA, error budget, postmortem. Carregue ao trabalhar com orquestração de containers, definir SLOs ou montar stack de observabilidade.
user-invocable: false
---

# Kubernetes, Observabilidade e SRE

### Kubernetes Moderno

**Gateway API (substituto do Ingress, GA desde 2023):**
- Recursos: `GatewayClass`, `Gateway`, `HTTPRoute`, `TCPRoute`, `GRPCRoute`
- Suporta traffic splitting, header rewrite, mTLS, multi-tenant nativo
- Implementações: Istio, Envoy Gateway, NGINX Gateway Fabric, Cilium

**HPA com custom metrics:**
- HPA + CPU/memória para serviços stateless com tráfego variável
- KEDA (Kubernetes Event-Driven Autoscaling) para escalar por fila (SQS, RabbitMQ, Kafka)
- **Nunca combinar HPA + VPA no mesmo recurso (CPU/mem)** — gera feedback loop; VPA em workloads de ML/batch, HPA em APIs

**VPA:** recomenda requests/limits corretos sem intervenção manual — use em `Off` mode para audit antes de aplicar.

---

### Observabilidade: Stack LGTM

Padrão moderno: **OpenTelemetry → Collector → {Loki, Tempo, Mimir} → Grafana**

| Componente | Função |
|---|---|
| **OTel Collector** | Único ponto de ingestão (logs, traces, métricas) |
| **Loki** | Logs indexados por labels (não full-text) — barato |
| **Tempo** | Traces distribuídos — gera RED metrics automaticamente via `metrics_generator` |
| **Mimir** | Prometheus escalável com retenção longa (S3/GCS backend) |
| **Grafana Alloy** | Substituto do Grafana Agent — coletor unificado |

**Vector como pipeline de logs de alta performance:**
- Escrito em Rust; 128k logs/s vs 105k do Fluent Bit; VRL (Vector Remap Language) para transforms tipadas
- Uso ideal: aggregator centralizado; Fluent Bit como DaemonSet leve (10-30MB RAM) nos nós

---

### IaC Atual

**OpenTofu** (fork open-source do Terraform, CNCF Sandbox desde abril 2025):
- 100% compatível com providers e módulos Terraform existentes
- Licença MPL-2.0 (vs BSL do Terraform — não permite uso em produtos SaaS concorrentes)
- Drop-in replacement: `tofu init`, `tofu plan`, `tofu apply`

**Pulumi** para times developer-centric:
- Infraestrutura em Python/TypeScript/Go — lógica complexa sem HCL workarounds
- `pulumi up --yes` em CI; state no Pulumi Cloud ou S3


### SRE — Site Reliability Engineering

**SLI / SLO / SLA — definições e exemplos:**

| Termo | O que é | Exemplo concreto |
|---|---|---|
| **SLI** | Métrica que mede o serviço (indicador) | % de requests com latência < 200ms |
| **SLO** | Objetivo interno a atingir | 99,9% de requests < 200ms em 30 dias |
| **SLA** | Acordo externo com consequência contratual | Se < 99,5%, cliente recebe crédito |

Regra geral: SLO interno deve ser mais rigoroso que o SLA externo — o SLO protege o SLA.

**Error Budget — como calcular e usar:**
- Fórmula: `error budget = 1 - SLO`. Um SLO de 99,9% = 0,1% de budget
- Em tempo: 99,9% SLO → **43 min/mês** de downtime permitido; 99,99% → **4,3 min/mês**
- Política de uso:
  - Budget > 50% restante → liberar deploys e features normalmente
  - Budget entre 10–50% → revisão obrigatória antes de cada deploy de risco
  - Budget esgotado → congelar mudanças, apenas correções de segurança e P1
  - Incidente que consome > 20% do budget em uma janela → postmortem obrigatório com ação P0

**Alerting por sintoma, não por causa:**
- Alertar em **burn rate do SLO**, não em CPU ou uso de disco
- Exemplo: `SLO burn rate > 14x` na última hora → alerta crítico (1h consumindo 14% do budget mensal)
- Runbook obrigatório em todo alerta: URL apontando para checklist de diagnóstico e remediação
- Ferramentas:
  - **Sloth** (`slok/sloth`): gera regras Prometheus e alertas multi-window/multi-burn-rate a partir de um YAML de SLO
  - **Grafana SLO**: cria 10–12 recording rules automaticamente + dashboard de error budget
  - **OpenSLO spec**: formato agnóstico de provedor para definir SLOs (suportado pelo Sloth)

**Severity Matrix — critérios claros:**

| Severidade | Critério | Resposta | Updates |
|---|---|---|---|
| **P1** | Serviço fora para todos / SLA em risco | Imediata, incident commander designado | A cada 15 min |
| **P2** | Impacto parcial / degradação visível | < 30 min para primeiro responder | A cada 30 min |
| **P3** | Impacto menor / workaround disponível | Horário comercial | Na resolução |
| **P4** | Cosmético / sem impacto operacional | Sprint seguinte | Na resolução |

**Blameless Postmortem — estrutura mínima:**
1. **Resumo do impacto**: duração, % de usuários afetados, receita/SLA impactado
2. **Timeline**: sequência de eventos com timestamps (detecção → ação → resolução)
3. **Causa raiz**: diagrama 5 Whys ou Fishbone — foco em sistema, não em pessoa
4. **Ações corretivas**: itens com responsável e prazo (mínimo 1 ação P0 se > 20% budget consumido)
5. **O que funcionou bem**: reforçar práticas que limitaram o impacto

**Toil Reduction:**
- Toil = trabalho manual, repetitivo, sem valor estratégico (reiniciar serviço, escalar manualmente)
- Meta SRE: toil < 50% do tempo da equipe; o restante em engenharia de confiabilidade
- Automatize qualquer operação que seja feita mais de 2× por mês: runbooks vivos → scripts → automação self-healing
