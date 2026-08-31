# Gorila Squad

Agentes de IA da Gorila Software House para **Claude Code** e **Cursor**.

## Time completo

| Agente | Personagem | Domínio |
|--------|-----------|---------|
| **Light** | Light Yagami — Death Note | Coordenador / Orquestrador de agentes |
| **Shikamaru** | Shikamaru — Naruto | Project Management → entrega plano ao Light |
| **Escanor** | Escanor — Nanatsu no Taizai | PHP + Laravel + API Docs |
| **Bulma** | Bulma — Dragon Ball | Frontend (Vue, React, Tailwind) + UX Research |
| **Ippo** | Ippo — Hajime no Ippo | Banco de dados (PostgreSQL, MySQL, Redis) |
| **Levi** | Levi — Attack on Titan | QA, testes e qualidade de código |
| **Nezuko** | Nezuko — Demon Slayer | Segurança e OWASP |
| **Saitama** | Saitama — One Punch Man | DevOps + SRE |
| **Gon** | Gon — Hunter x Hunter | Mobile (React Native, Flutter) |
| **Uraraka** | Uraraka — My Hero Academia | Python + Node.js |
| **Kurama** | Kurama — Yu Yu Hakusho | Arquitetura de Software e DDD |
| **Ryuk** | Ryuk — Death Note | Data e Business Intelligence |

## Fluxo de trabalho

```
Ideia → SHIKAMARU (planeja) → LIGHT (executa orquestrando especialistas) → Entrega
```

O `LIGHT` pode acionar qualquer agente diretamente quando a tarefa já está clara.

---

## Skills de referência (conhecimento sob demanda)

Cada agente carrega o arquivo dele inteiro em contexto toda vez que é invocado. Para não pagar por conhecimento que a tarefa não usa, o **núcleo fica no agente** e o **periférico virou skill**, carregada só quando o assunto aparece.

Exemplo: o `ESCANOR` mantém PHP 8.3/8.4 e Laravel 11/12/13 no próprio arquivo — isso *é* ele. Já a referência de OpenAPI/Swagger saiu para uma skill; ele a invoca apenas quando a tarefa é documentar uma API.

| Skill | Conteúdo | Agente que aciona |
|---|---|---|
| `api-docs-ref` | OpenAPI 3.1, Scramble vs L5-Swagger vs Scribe, Sanctum no spec, contract-first | `ESCANOR` |
| `infra-k8s-sre` | Kubernetes, stack LGTM, IaC (Terraform/Pulumi/OpenTofu), SLI/SLO/error budget | `SAITAMA` |
| `react-ref` | React 19: Server Components, Actions, `use()`, compilador | `BULMA` |
| `ux-research-design` | Wireframes, fluxos, usability testing, WCAG 2.2, design tokens | `BULMA` |
| `db-extras` | MySQL 9.x, PgBouncer vs Supavisor, pgvector | `IPPO` |
| `testes-frontend-ts` | Vitest 2/3, Playwright 1.44+, TypeScript strict mode | `LEVI` |
| `templates-doc-pm` | Templates de PRD, RFC e ADR; ClickUp; feature flags | `SHIKAMARU` |
| `metricas-gestao` | DORA Metrics, RICE, MoSCoW, RACI, Task-Relevant Maturity | `LIGHT` |

**Impacto medido:** os 12 agentes caíram de 115.296 para 95.252 caracteres — **−26%**, cerca de 5.700 tokens fora do contexto base de toda invocação. Os cortes maiores: `SAITAMA` −41%, `BULMA` −33%, `SHIKAMARU` −25%.

As skills usam `user-invocable: false`: são invocadas pelos agentes, não aparecem no seu menu `/`. Os agentes que as consomem têm `Skill` na lista `tools:` do frontmatter.

### Adicionando conhecimento novo

Antes de engordar um agente, pergunte: **isso é o núcleo dele, ou é periférico?**

- **Núcleo** (o que ele é, usado na maioria das tarefas) → direto no `claude-agents/<agente>.md`
- **Periférico** (stack alternativa, tema ocasional, material de referência) → nova skill em `claude-skills/<nome>/SKILL.md`, mais uma linha na tabela "Conhecimento sob demanda" no fim do arquivo do agente

---

## Pré-requisitos

- [Claude Code](https://claude.ai/code) instalado
- Git configurado com acesso a este repositório

---

## Instalação

### 1. Clone o repositório

```bash
git clone git@github.com:rotteny/gorila-squad.git
cd gorila-squad
```

### 2. Instale o squad

**Apenas Claude Code:**
```bash
./setup.sh
```

**Claude Code + Cursor (informando o projeto):**
```bash
./setup.sh /caminho/do/seu/projeto
```

---

## Como usar

```
/light      implementa o módulo de assinaturas completo
/shikamaru  planeja a feature de relatórios de agendamentos
/escanor    cria um endpoint de webhook com validação de assinatura
/bulma      cria um componente de calendário responsivo com PrimeVue
/ippo       otimiza as queries de relatório que estão lentas
/levi       escreve testes Pest para o módulo de planos
/nezuko     faz security review do fluxo de autenticação
/saitama    configura o GitHub Actions com deploy automático
/gon        cria a tela de agendamento no app React Native
/uraraka    cria um script Python de importação de clientes via CSV
/kurama     define a arquitetura do módulo de notificações
/ryuk       cria um relatório de agendamentos por período
```

---

## Atualizar o squad

```bash
git pull
./setup.sh                        # atualiza Claude Code
./setup.sh /caminho/do/projeto    # atualiza também o Cursor
```

O `setup.sh` instala, nesta ordem: agentes em `~/.claude/agents`, commands em `~/.claude/commands`, skills em `~/.claude/skills`, a seção do squad no `~/.claude/CLAUDE.md` global (entre marcadores, preservando o resto do arquivo) e, se você passar um projeto, as Cursor Rules em `.cursor/rules`.
