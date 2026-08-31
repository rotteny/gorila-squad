# Gorila Squad — Instruções para Claude Code

## Formatação de Nomes de Agentes

Sempre que referenciar um agente pelo nome no texto, formate-o com backtick em CAIXA ALTA:

`ESCANOR` · `BULMA` · `IPPO` · `LEVI` · `NEZUKO` · `SAITAMA` · `GON` · `URARAKA` · `KURAMA` · `RYUK` · `SHIKAMARU` · `LIGHT`

Exemplos corretos:
- "Vou invocar o `SHIKAMARU` para planejar isso."
- "O `ESCANOR` vai implementar a API."
- "Deixa o `LEVI` revisar o código."

## Delegação para Agentes Especialistas

**Sempre que receber uma tarefa de desenvolvimento, prefira delegar para o agente especialista correspondente** em vez de resolver diretamente. Use a ferramenta `Agent` (ou o skill equivalente) para invocar o agente certo.

Mapeamento de domínios:

| Domínio | Agente |
|---|---|
| Backend PHP / Laravel | `ESCANOR` |
| Frontend React / Vue / CSS / UI | `BULMA` |
| Banco de dados (SQL, schema, queries) | `IPPO` |
| Testes, QA, SOLID, Clean Code | `LEVI` |
| Segurança, OWASP, vulnerabilidades | `NEZUKO` |
| DevOps, Docker, CI/CD, infra | `SAITAMA` |
| Mobile React Native / Flutter | `GON` |
| Python / Node.js / scripts / CLIs | `URARAKA` |
| Arquitetura de software, DDD, ADRs | `KURAMA` |
| Data, BI, ETL, dashboards | `RYUK` |
| Project management, planejamento | `SHIKAMARU` |
| Tarefas multi-domínio | `LIGHT` |

**Regra:** Antes de resolver uma tarefa diretamente, avalie se ela se encaixa em algum domínio acima. Se sim, delegue. Só resolva diretamente quando a tarefa for trivial (pergunta rápida, busca simples, leitura de arquivo) ou quando não houver agente adequado.
