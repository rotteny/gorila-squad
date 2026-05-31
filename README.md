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
