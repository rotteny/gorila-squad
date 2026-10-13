# Resumo: Guia ANPD — Cookies e proteção de dados pessoais

Boas práticas da Autoridade Nacional de Proteção de Dados (outubro/2022, versão 1.0). **Não é lei** e não isenta de cumprir a LGPD. Este arquivo é atalho para redigir; **não substitui o PDF**.

Carregue só se o produto tiver cookies ou rastreador equivalente. Sem cookies, não abra este arquivo.

## Fonte (esclarecimentos e exemplos)

Sempre comece pela **página de publicação**. O governo pode trocar o PDF; o atalho de arquivo pode quebrar.

- Página (costuma ser HTML, apesar do `.pdf` no caminho):  
  https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-cookies-e-protecao-de-dados-pessoais.pdf
- Download atual (pode mudar):  
  https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-cookies-e-protecao-de-dados-pessoais.pdf/@@display-file/file

No PDF, os **exemplos ilustrativos** estão nos capítulos *Cookies e a LGPD* e *Banners de cookies* (exemplos 1 a 7). Se este resumo não resolver a dúvida — base legal, banner de dois níveis, política junto à privacidade —, baixe o guia (mesmo `curl` da seção 0 do `SKILL.md`) e leia o capítulo correspondente. Sugestões à ANPD: Plataforma Fala.BR (`https://falabr.cgu.gov.br/`).

O guia também vale, em geral, para tecnologias semelhantes de rastreamento (pixels, apps móveis), com as peculiaridades de cada contexto.

## Conceito e categorias

Cookies são arquivos no dispositivo do usuário. Podem guardar login, idioma, carrinho; também medir audiência e veicular anúncio. Se identificam pessoa, direta ou indiretamente, ou formam perfil comportamental, são **dado pessoal** (LGPD, inclusive art. 12, § 2º).

Um mesmo cookie pode cair em mais de uma categoria.

| Corte | Tipos |
|---|---|
| Quem gere | **Próprios** (first-party, o sítio visitado) ou **de terceiros** (outro domínio: anúncio, conteúdo embutido) |
| Necessidade | **Necessários**: sem eles o titular não realiza a atividade principal do sítio. Só o essencial ao serviço pedido — não o interesse extra do controlador. **Não necessários**: dá para desligar sem impedir o serviço (rastreio, desempenho, anúncio, conteúdo embutido) |
| Finalidade | Analíticos/desempenho; funcionalidade (lembrar preferência); publicidade (perfil e anúncio personalizado) |
| Retenção | **Sessão** (some ao fechar o navegador) ou **persistentes** (minutos a anos). Prefira sessão quando bastar; persistente com prazo limitado à finalidade |

A distinção necessário / não necessário define a hipótese legal.

## LGPD aplicável a cookies

Marco Civil da Internet (Lei nº 12.965/2014) já trata privacidade na rede. A LGPD amplia: princípios, direitos, bases legais.

- **Finalidade, adequação, necessidade** (art. 6º, I–III): finalidade específica e informada; sem tratamento posterior incompatível; só o dado pertinente. “Melhorar a experiência” ou aceite de termos gerais **não** serve. Se a finalidade dá para atingir com meio menos gravoso, não trate.
- **Livre acesso e transparência** (art. 6º, IV e VI; art. 9º): forma, prazo de retenção, finalidades, compartilhamento, direitos — claros, precisos, fáceis de achar.
- **Direitos** (art. 18): acesso, eliminação, revogação do consentimento, oposição. Procedimento **gratuito e facilitado**. Mecanismo próprio de gerenciar cookies (rever permissões). Ajuste no **navegador é complementar**; não substitui esse mecanismo.
- **Retenção** (art. 16): eliminar quando a finalidade acabar ou o titular pedir, salvo exceção legal. Prazo indeterminado, excessivo ou desproporcional não cabe.
- Coleta indiscriminada e rastreamento ilimitado, sem finalidade clara e sem base legal, são incompatíveis com a LGPD.

## Hipóteses legais (as mais usuais)

Não há hierarquia entre bases. Consentimento e legítimo interesse são as mais comuns; outras bases do art. 7º (e art. 11, se sensível) podem caber no caso concreto.

### Consentimento (arts. 7º, I, e 8º)

Livre, informado e inequívoco.

- **Livre:** aceitar ou recusar sem punição. Aceite integral forçado, sem opção real, não serve.
- **Informado:** finalidade específica, forma, retenção e o mais do art. 9º. Mudou a premissa → novo consentimento (ou outra base).
- **Inequívoco:** manifestação clara e positiva. Sem inferência, sem omissão, sem “continuar navegando = aceito”, sem caixa pré-marcada.
- Dado **sensível:** consentimento específico e destacado (art. 11, I).
- **Revogação** a qualquer momento, tão fácil quanto autorizar (art. 8º, § 5º). O controlador prova o consentimento (boa prática: registrar).

**Não** use consentimento para cookie **estritamente necessário**: não há escolha real. Tampouco quando o tratamento for compulsório por obrigação legal típica de ente público.

**Use** consentimento para cookies **não necessários** (anúncio, perfil, o que o sítio funciona sem).

No PDF: **exemplo 1** (único botão “estou de acordo”, finalidade vaga — inadequado) e **exemplo 2** (aceitar todos / rejeitar / gerenciar; segundo nível; não necessários desligados por padrão — falta só a revogação).

### Legítimo interesse (art. 7º, IX)

Só dado **não sensível**. Interesse lícito do controlador ou de terceiro, se não prevalecerem direitos e liberdades do titular. Avaliar **antes** de tratar: expectativa legítima, proporcionalidade, segurança, transparência. O titular pode **opor-se** (art. 18, § 2º).

Em geral cabe em cookies **estritamente necessários** (autenticação, pagamento, carrinho) — apoio à atividade e ao serviço pedido (art. 10, I e II). Poder público: LI só se não houver vínculo claro com prerrogativa estatal típica.

**Analíticos:** podem caber em LI se a finalidade for só padrão/tendência, dado **agregado**, sem cruzar com outro rastreador e **sem perfil**.

**Publicidade**, cookie de **terceiro**, perfil, previsão de comportamento, rastreio entre sítios: o balanceamento em geral faz prevalecer o titular → **consentimento** é a base mais adequada.

No PDF: **exemplo 3** (cookies necessários de livraria online) e **exemplo 4** (estatística agregada de visitação, sem compartilhar nem cruzar).

## Política de cookies e banner

São coisas distintas.

- **Banner:** aviso resumido no acesso + controle (aceitar, recusar, gerenciar).
- **Política:** detalhe (finalidades, retenção, terceiros, art. 9º). Pode ser (i) seção da Política de Privacidade, (ii) página separada com link no banner, ou (iii) nas camadas do banner. As três valem se a informação for clara e acessível.

Só a política, escondida num link de rodapé, pode não bastar no primeiro acesso. O guia recomenda o titular ver a informação ao entrar — p. ex. banner de segundo nível. No PDF: **exemplo 7**.

## Banners — o que observar

**Primeiro nível:** botão para **rejeitar todos os não necessários**, fácil de ver, no mesmo destaque de aceitar; opção de gerenciar; link para direitos (saber mais, eliminar, opor-se, revogar) e para a política.

**Segundo nível:** categorias; descrição simples da finalidade de cada uma; consentimento **por finalidade**; cookies baseados em consentimento **desativados por padrão**; como bloquear no navegador (e aviso se não der para desligar por aí).

## Banners — o que evitar

- Um único botão (“concordo”, “aceito”, “ciente”) quando a base for consentimento.
- Destacar só o aceite; esconder rejeitar ou configurar.
- Impedir rejeitar os não necessários.
- Não necessários já ligados, exigindo desligar um a um.
- Sem segundo nível.
- Sem mecanismo próprio de revogar e de opor-se (só o navegador).
- Sem opções por finalidade distinta.
- Texto só em idioma estrangeiro.
- Lista granular demais (fadiga; o titular não consegue manifestar vontade clara).
- Consentimento atado ao aceite integral, sem escolha.

No PDF: **exemplo 5** (só “Aceitar” — inadequado) e **exemplo 6** (primeiro e segundo nível, rejeitar não necessários em destaque, categorias desligadas por padrão — adequado).

## Ao redigir

Não invente cookie, base legal nem banner. Inventário e formato do texto: seção 2.1 do `SKILL.md`. Molde de lista nome / vigência / finalidade: `exemplo/COOKIES.txt` (MPF), sem copiar os cookies deles.

Dúvida que este resumo não fecha: abra o guia no link da seção **Fonte**.
