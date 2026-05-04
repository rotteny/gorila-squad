# Gorila Squad

Agentes de IA da Gorila Software House para **Claude Code** e **Cursor**.

## Agentes

| Agente | Especialidade |
|--------|--------------|
| **Bulma** | Frontend — React, Vue, CSS, UI/UX |
| **Escanor** | Backend — Python, Node.js, PHP |
| **Gon** | Mobile — React Native, Flutter |
| **Levi** | QA & Testes — SOLID, Clean Code, PSR |
| **Nezuko** | Segurança — OWASP, Auth, Hardening |
| **Saitama** | DevOps — Docker, CI/CD, Infra |
| **Shikamaru** | Project Management — Planejamento, Docs |

---

## Pré-requisitos

- [Claude Code](https://claude.ai/code) instalado
- [Cursor](https://cursor.com) instalado (opcional)
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

### Claude Code (terminal)

Invoque um agente pelo nome no chat:

```
/bulma cria um componente de card responsivo
/escanor cria uma API REST em FastAPI
/levi escreve testes para esse serviço
/nezuko faz security review desse controller
/saitama cria o Dockerfile para esse projeto
/shikamaru planeja a feature de autenticação
```

Ou peça diretamente que o Claude delegue automaticamente ao agente correto.

### Cursor

Após instalar as rules no projeto com `./setup.sh /caminho/do/projeto`, use `@` para acionar:

```
@bulma cria um componente de tabela com paginação
@escanor refatora essa função seguindo SOLID
@nezuko analisa vulnerabilidades nesse endpoint
@saitama configura o GitHub Actions para esse projeto
```

---

## Atualizar o squad

```bash
git pull
./setup.sh                        # atualiza Claude Code
./setup.sh /caminho/do/projeto    # atualiza também o Cursor
```
