---
name: db-extras
description: Referência de MySQL 9.x, connection pooling (PgBouncer vs Supavisor) e indexação vetorial com pgvector. Carregue só quando o banco for MySQL, quando o problema for saturação de conexões, ou em busca semântica/embeddings — o padrão dos projetos é PostgreSQL direto.
user-invocable: false
---

# MySQL, Pooling e pgvector

### MySQL 9.x — Novidades Relevantes

- **VECTOR type** (9.0): coluna `VECTOR(dimensions)` para até 16.383 dimensões (float 4 bytes cada); sem suporte a índices ainda — busca é full-scan com `DISTANCE()`
- **JavaScript stored procedures** (Enterprise/HeatWave): MLE com ECMAScript 2023, strict mode; 9.2 adicionou `START TRANSACTION`/`COMMIT` via API JS; 9.3 suporte completo a `DECIMAL`
- **EXPLAIN ANALYZE FORMAT=JSON** melhorado para análise programática de planos

```sql
-- VECTOR no MySQL 9.x
CREATE TABLE embeddings (id BIGINT AUTO_INCREMENT PRIMARY KEY, vec VECTOR(1536));
SELECT id, DISTANCE(vec, '[0.1, 0.2, ...]', 'COSINE') AS dist FROM embeddings ORDER BY dist LIMIT 10;
```

### Pooling Moderno — PgBouncer vs Supavisor

| Critério | PgBouncer | Supavisor |
|---|---|---|
| Linguagem | C (single-thread) | Elixir (multi-thread) |
| Latência | ~2ms (referência) | ~4ms (+80-160%) |
| Throughput pico | ~44k tps | ~22k tps |
| Prepared statements em transaction mode | Não suportado | Suportado (v1.0+) |
| Multi-tenant isolation | Manual | Nativo por tenant |
| RAM por 1k clientes | ~2MB | Maior |
| **Quando usar** | Maioria dos projetos self-hosted | Serverless, multi-tenant, Supabase |

Migração PgBouncer → Supavisor: apenas troca de connection string, sem mudança de código.

### Indexação Vetorial — pgvector para Projetos com AI

**Instalação:** `CREATE EXTENSION vector;` — disponível no RDS, Supabase, Neon, Railway.

**Tipos de índice:**

| | HNSW | IVFFlat |
|---|---|---|
| Build time | Lento | Rápido |
| Memória | Alta | Baixa |
| Query speed | Muito rápido | Moderado |
| Treinamento | Não precisa | `ANALYZE` obrigatório antes |
| Escala ideal | Até ~50M vetores | Centenas de milhões |

```sql
-- Criar tabela com vetor de embeddings (ex: OpenAI text-embedding-3-small = 1536 dims)
CREATE TABLE documents (id BIGSERIAL PRIMARY KEY, content TEXT, embedding vector(1536));

-- Índice HNSW (recomendado para a maioria dos casos)
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

-- Busca por similaridade (cosine distance)
SELECT id, content, 1 - (embedding <=> '[...]'::vector) AS similarity
FROM documents ORDER BY embedding <=> '[...]'::vector LIMIT 10;

-- Hybrid search: semântica + full-text
SELECT id, content,
  ts_rank(to_tsvector('portuguese', content), plainto_tsquery('portuguese', $1)) AS text_score,
  1 - (embedding <=> $2::vector) AS vec_score
FROM documents
WHERE to_tsvector('portuguese', content) @@ plainto_tsquery('portuguese', $1)
ORDER BY vec_score DESC LIMIT 20;
```

**Ajuste de performance:** `SET hnsw.ef_search = 100;` por sessão para maior recall; padrão é 40.
