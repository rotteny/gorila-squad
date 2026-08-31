---
name: metricas-gestao
description: Métricas e frameworks de gestão de times e produto: DORA Metrics (deploy frequency, lead time, CFR, MTTR), priorização RICE, escopo MoSCoW, RACI, Task-Relevant Maturity e handoff de tasks com dependências. Carregue ao medir maturidade de time, priorizar features concorrentes ou definir escopo de sprint.
user-invocable: false
---

# Métricas e Frameworks de Gestão


### DORA Metrics — baseline de maturidade de times

Use DORA para diagnosticar onde o time está antes de propor processos:

| Métrica | Elite (2025) | O que indica |
|---|---|---|
| Deployment Frequency | Múltiplas vezes/dia | Maturidade de CI/CD e autonomia de deploy |
| Lead Time for Changes | < 1 hora | Eficiência do processo dev→prod |
| Change Failure Rate | < 5% | Qualidade de testes e review |
| Failed Deploy Recovery Time | < 1 hora | Resiliência operacional |
| Rework Rate | < 10% | Qualidade de requisitos upstream |

Se Lead Time alto → gargalo em review ou CI lento → acionar `SAITAMA` + `LEVI`.
Se CFR alto → investir em testes antes de aumentar frequência → acionar `LEVI`.
Se Rework Rate alto → requisitos ruins na origem → acionar `SHIKAMARU`.

### RICE — priorização de features concorrentes

Quando houver múltiplas features para coordenar, priorize por:

```
RICE Score = (Reach × Impact × Confidence) / Effort
```

- **Reach**: quantos usuários afeta no período (ex: usuários/mês)
- **Impact**: escala 0.25 / 0.5 / 1 / 2 / 3 (mínimo a massivo)
- **Confidence**: % de certeza sobre os números (100% = dados duros, 50% = achismo)
- **Effort**: pessoa-meses de trabalho total do time

Regra prática: itens com RICE > 10 têm prioridade. Itens com Confidence < 50% precisam de validação antes de implementar — acione o `SHIKAMARU`.

### MoSCoW para escopo de sprint

Quando o escopo está grande demais para o prazo:
- **Must have**: sem isso o MVP não funciona
- **Should have**: valor alto, mas o sistema opera sem
- **Could have**: nice-to-have, entra se sobrar tempo
- **Won't have**: explicitamente fora — documenta para não virar surpresa depois

### Async-first delegation — como coordenar sem reuniões

O modelo fan-out (scatter-gather) é o padrão de delegação para tasks paralelas:

1. Você define o contrato entre agentes antes de qualquer um começar (schema de API, estrutura de dados)
2. Dispara os agentes em paralelo com contexto completo
3. Coleta os resultados
4. Integra e verifica conflitos
5. Entrega ao usuário

Regra crítica para paralelismo: **dois agentes nunca editam o mesmo arquivo simultaneamente**. Se houver risco de conflito de arquivo, serializa a execução.

### RACI aplicado à coordenação de agentes

Para cada task delegada, a matriz é sempre:

| Papel | Quem |
|---|---|
| **Responsible** (executa) | O agente especialista |
| **Accountable** (responde pelo resultado) | `LIGHT` (você) |
| **Consulted** (dá input antes) | Outros especialistas com dependência |
| **Informed** (recebe resultado) | O usuário |

Você nunca é Responsible por código — mas é sempre Accountable pela entrega integrada.

### Task-Relevant Maturity — como calibrar o nível de detalhe

Cada agente especialista tem TRM alto no seu domínio. Isso significa:
- Você não precisa explicar *como* fazer — só *o que* entregar e *quais restrições*
- Contextualizar bem é suficiente — micro-gerenciar é contra-produtivo
- Se um especialista pede mais contexto, você falhou em contextualizar — reveja o prompt de delegação

### Handoff de tasks com dependências

O formato padrão de handoff entre agentes:

```
ENTREGA: [nome do agente que entregou]
ARTEFATO: [o que foi produzido — migration, endpoint, componente]
CONTRATO: [interface exposta para o próximo — schema, URL, props]
PRÓXIMO: [qual agente consome isso e o que precisa saber]
```

Você gerencia esses handoffs explicitamente. Nunca assume que um agente leu o output do outro.
