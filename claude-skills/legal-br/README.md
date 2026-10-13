# Legal BR - Skill para Claude Code

Skill personalizada para apoio à análise jurídica brasileira, com uma cópia local das fontes primárias.

## O que vem no pacote

- `SKILL.md`, `references/` e `templates/` - o roteiro de análise.
- `fontes/` - biblioteca local com 29 fontes oficiais (~11 MB): leis do Planalto, guias e resoluções da ANPD, ECA Digital.
- `ATUALIZAR-FONTES.bat` - rebaixa e valida a biblioteca local.
- `FONTES-OFICIAIS.md` - catálogo com o link oficial de cada arquivo.

## Instalação

Na raiz do pacote, execute:

```text
INSTALAR-LEGAL-BR.bat
```

Ele copia tudo para `%USERPROFILE%\.claude\skills\legal-br`. Rodar de novo atualiza a instalação existente (pede confirmação antes de substituir).

Para instalar à mão, copie a pasta `legal-br` inteira para:

```text
%USERPROFILE%\.claude\skills\
```

O resultado deve ser:

```text
C:\Users\SEU_USUARIO\.claude\skills\legal-br\SKILL.md
```

Depois abra ou reinicie o Claude Code, se a pasta `.claude\skills` ainda não existia quando a sessão foi iniciada.

Teste:

```text
/legal-br
```

ou escreva normalmente:

```text
Analise os requisitos jurídicos desta funcionalidade conforme a legislação brasileira.
```

## Instalação somente em um projeto

Copie `legal-br` para:

```text
SEU_PROJETO\.claude\skills\legal-br\
```

O resultado deve ser `SEU_PROJETO\.claude\skills\legal-br\SKILL.md`.

## Atualizar a biblioteca local

```text
ATUALIZAR-FONTES.bat
```

O script baixa as 29 fontes do Planalto, da ANPD e do Diário Oficial e **valida cada arquivo** antes de gravar: PDF precisa começar com `%PDF-`, HTML não pode ser página de erro do portal. O download vai para um arquivo temporário e só substitui o original depois de passar na validação - uma falha nunca destrói a cópia boa anterior.

Ao final gera `ULTIMA-ATUALIZACAO.txt`, `CHECKSUMS-SHA256.txt` e, se algo falhar, `FALHAS-DOWNLOAD.txt`.

Se você atualizar as fontes na pasta do projeto, rode `INSTALAR-LEGAL-BR.bat` de novo para levar a atualização até a skill instalada.

## Observação

Esta skill é uma ferramenta de apoio à análise e ao desenvolvimento de produtos. Ela orienta o Claude a consultar as fontes locais, verificar a vigência em fonte oficial e distinguir fato legal, interpretação, recomendação e risco. Não substitui parecer de advogado.

A biblioteca local é um snapshot - confira a data em `ULTIMA-ATUALIZACAO.txt`. A própria skill exige verificação de vigência em fonte oficial para conclusões jurídicas atuais.
