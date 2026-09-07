---
description: Invoca o Arquiteto de Agentes, que cria novos agentes da squad seguindo a arquitetura existente — frontmatter, persona, regras e skills sob demanda
argument-hint: <descreva o domínio do agente que você precisa>
---

Invoque o subagente **arquiteto-de-agentes** para criar um agente novo:

$ARGUMENTS

O Arquiteto irá ler os agentes existentes, checar se o domínio já está coberto e entregar o pacote completo — definição do agente, slash command e a entrada na tabela de roteamento do `LIGHT` — no mesmo formato dos demais, com o conhecimento periférico como skill sob demanda.
