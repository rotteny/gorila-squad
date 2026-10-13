---
name: gerador-lgpd
description: Cria política de privacidade e termos de uso (LGPD) para software open source ou grátis. Use ao pedir gerador-lgpd, PRIVACIDADE.md, TERMOS.md ou privacy policy de app livre.
license: MIT
compatibility: Requires internet to fetch the current LGPD from planalto.gov.br
metadata:
  author: DanielSunami
  version: "1.3"
---

# Privacidade e termos (OSS / grátis)

Produz **os dois** arquivos de texto, sempre: `PRIVACIDADE.md` e `TERMOS.md`. A diferença entre eles é o ponto da skill. Não é parecer jurídico. Não inventa controlador, DPO, consentimento genérico, base legal nem anonimização.

A skill **só escreve texto** (Markdown no repositório). Não publica página, não sobe servidor, não registra domínio. **Cabe ao usuário** colocar os documentos num **link público** — o caminho usual é HTML num servidor web (`/privacidade`, `/termos`). Quem precisa apontar política em loja de app, rodapé ou art. 9º usa esse URL. No fim da entrega, lembre isso em uma linha.

## Os dois documentos

A LGPD **não exige termo de uso**. A GDPR também não. O que essas leis pedem, **quando há controlador**, é informação sobre o **tratamento** — isso vai na política de privacidade.

O termo de uso ainda vale, por outro motivo: o software é livre ou grátis. Alguém vai copiar, quebrar, perder dado no navegador ou hospedar um fork. O termo diz o que a licença já diz em prosa, para quem não abre o `LICENSE`:

- pode usar, copiar, modificar, distribuir (nos limites da licença);
- **não há garantia** — o código não promete funcionar, servir para o seu caso, estar disponível nem estar livre de erro (em inglês isso é o “AS IS”; em português **não** escreva “como está”. Use “sem garantia” e, se precisar de uma frase, “oferecido sem promessa de funcionamento”);
- autores não respondem por perda no dispositivo, conteúdo que o usuário inserir, nem por cópia que um terceiro hospedar;
- quem sobe um servidor com o código assume a própria política e os próprios termos.

| Arquivo | Responde | Não é |
|---|---|---|
| `PRIVACIDADE.md` | O que acontece com dado. Quem trata (se alguém). Direitos. | Licença, SLA, “pode copiar?” |
| `TERMOS.md` | Pode usar de graça? Tem garantia? De quem é o código? E o fork? | Aviso LGPD / lista de dados |

Gere os dois, mesmo no modo A (autores não tratam). A política nesse caso é curta e honesta; o termo carrega uso livre e ausência de garantia. Não funda os dois num arquivo só. Não chame o termo de “exigência da LGPD”.

## 0. Lei vigente (obrigatório, primeiro passo)

Antes de perguntar ou redigir, baixe o texto da LGPD nesta URL oficial:

https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm

Use a ferramenta HTTP que o ambiente tiver: WebFetch, browser, `curl`, etc. O HTML do Planalto costuma vir em latin-1 (ISO-8859-1); se o texto aparecer com `Ã` ou `�`, recodifique.

Exemplo com `curl`, se houver shell:

```bash
curl -sL -A 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36' \
  'https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm' \
  | iconv -f latin1 -t utf-8
```

Leia de novo: arts. 3º–5º, 6º–9º, 11–12, 16, 18, 20. Se o fetch falhar, diga isso ao usuário e siga com o que já estiver neste skill, sem fingir que leu a página.

## 1. Controlador, operador, software

- **Controlador** (art. 5º, VI): quem **decide** finalidade e meios do tratamento.
- **Operador** (art. 5º, VII): quem trata **em nome** do controlador. Pessoa distinta. Quem decide e executa sozinho no próprio aparelho **não** é operador de si mesmo — é só controlador (se a lei alcançar).
- **Software / autores:** se o binário só grava no dispositivo do usuário e os autores **não recebem** o conteúdo, eles **não são** controlador nem operador. São ferramenta (como um bloco de notas).
- **Uso só particular e não econômico** por pessoa natural: a lei pode não se aplicar (art. 4º, I).
- **Uso no trabalho:** controlador é o usuário ou a organização. Só existe operador se um terceiro tratar por eles (hospedagem, SaaS). Fork com servidor: **quem hospeda se torna responsável** e precisa da própria política.
- **Anonimização** (arts. 5º, XI, 12, 16): dever de quem trata. Se os autores não tratam, não coloque item de anonimização como obrigação do software. No art. 18, diga que anonimizar/bloquear **não existem como função**, se for o caso.
- **Dado sensível** (art. 5º, II / art. 11): só se o app **pedir** (campo de saúde, etc.). Texto livre e áudio podem carregar dado de terceiro; a responsabilidade é de quem anota. Voz gravada como anexo, em geral, é dado pessoal — biométrico só se usada para identificar.
- **Consentimento** (arts. 7º, I, e 8º): não use “ao usar você consente” como base dos autores se eles não tratam. Autorização genérica é nula (art. 8º, § 4º).
- **Art. 9º e 18:** se houver controlador, informe finalidade, forma, duração, quem é, contato, compartilhamento, responsabilidades e os direitos do art. 18 **um a um**. Se não houver tratamento dos autores, mapeie cada direito para o que o usuário já faz no dispositivo e marque o que não cabe (consentimento nosso, ANPD contra os autores).

Não invente DPO, RIPD, prazo de guarda nosso, criptografia extra, mailing nem base legal dos autores.

## 2. Descobrir o produto

Se estiver num repositório, inspecione armazenamento, rede, analytics, login, backup, arquivos/áudio. Preencha o quadro abaixo com o que já souber. O que faltar, **pergunte** (pode agrupar; não despeje questionário de escritório).

Quadro mínimo:

| Campo | Precisa para |
|---|---|
| Nome e uma linha do que o software faz | os dois docs |
| Autores e canal de contato (URL ou e-mail) | art. 9º / termos |
| Licença do código (MIT, etc.) | termos |
| Onde o dado vive: só o dispositivo / servidor dos autores / terceiro | papel dos autores |
| Conta, login, cookie, telemetria, crash, ads, pagamento | tratamento |
| O que o usuário insere (campos, texto livre, arquivo, áudio) | natureza dos dados |
| Backup / export / sync | portabilidade e saída |
| Quem hospeda o “oficial” vs clone local | cláusula de fork |
| País / lei (padrão: Brasil) | fecho |

Pergunte também se o app **pede** dado sensível ou só pode aparecer em texto/áudio.

Se aparecer cookie (ou rastreador equivalente: pixel, tag de anúncio), não redija ainda: faça o inventário da seção 2.1 e confirme com o usuário.

## 2.1. Cookies (só se existirem)

O fluxo padrão **não muda**: os dois arquivos continuam `PRIVACIDADE.md` e `TERMOS.md`. Sem cookie no produto, pule esta seção. Não invente política de cookies, Analytics, pixel nem banner.

Havendo cookies — próprios ou de terceiros; de sessão ou persistentes; necessários, analíticos, de funcionalidade ou de publicidade — avalie **cada um** com minúcia. Cookie que o sítio dos autores envia ou lê tende a modo B. Terceiro (analytics, anúncio, rede social embutida) também entra no quadro, mesmo quando os autores “só hospedam o script”.

### Inventário (por cookie)

| Campo | Precisa para |
|---|---|
| Nome | o titular achar no navegador (exceção à regra de não citar detalhe técnico) |
| Dono / domínio | próprio (first-party) ou terceiro |
| O que faz | finalidade **específica**; sem “melhorar a experiência” |
| Categoria | necessário ou não necessário; analítico; funcionalidade; publicidade |
| Duração | sessão ou prazo concreto; sem retenção indeterminada |
| Dado e compartilhamento | se identifica pessoa; se vai a terceiro |
| Como desabilitar | configuração do navegador **e** o mecanismo próprio do sítio, se existir |
| Revogar consentimento / opor-se | tão fácil quanto autorizar (art. 8º, § 5º; art. 18) |
| Base legal | necessário: em geral legítimo interesse (art. 7º, IX). Não necessário: em geral consentimento (arts. 7º, I, e 8º). Publicidade e perfil: consentimento. Sem “ao navegar, você consente”. Sem caixa pré-marcada. |

Confirme essa lista na seção 3. Não escreva cookie que o código não cria.

### Onde vai o texto

A ANPD aceita a política de cookies como (i) **seção** da Política de Privacidade, (ii) **documento separado**, ou (iii) nas camadas do banner — desde que as informações do art. 9º estejam claras e acessíveis. Pergunte o formato. Se o usuário não escolher, use **seção na privacidade** (não cria arquivo extra). `COOKIES.md` só se ele pedir ou se o inventário não couber numa seção.

Remissão cruzada: privacidade aponta para cookies; cookies apontam para privacidade.

Molde de estrutura (definição, categorias, lista nome / vigência / finalidade, terceiros, controle no navegador, contato): `exemplo/COOKIES.txt`, transcrição da Política de Cookies do MPF (`https://www.mpf.mp.br/servicos/lgpd/politicas/privacidade/politica-de-cookies`). Use a ordem e o tipo de informação. Não copie o texto do MPF nem os cookies deles (`_ga`, Google Analytics, etc.).

A skill **só escreve texto**. Não implementa banner, CMP nem script. Se o produto já tem banner, descreva o que ele faz. Se há cookie **não necessário** e não há banner, avise o usuário (não invente o banner no Markdown). O que o guia espera do banner, o que evitar e os exemplos: `references/anpd-cookies.md`.

### Guia da ANPD (quando houver cookies)

Havendo cookies, leia `references/anpd-cookies.md` **antes** de redigir a parte de cookies. Sem cookies, **não** abra esse arquivo.

O resumo aponta para a página da ANPD e para os exemplos 1–7 do PDF. Dúvida que o resumo não fecha: baixe o guia pelos links que estão lá (página de publicação primeiro; o PDF direto pode mudar). Se o fetch falhar, diga isso e siga com o resumo, sem fingir que leu o PDF.

## 3. Confirmar antes de escrever (obrigatório)

Mostre um **quadro de fatos** com o que você infereu e o que o usuário disse:

- papéis: autores (nem controlador nem operador **ou** controlador, com identificação) e, se houver, operador
- onde o dado fica
- o que entra no armazenamento
- o que **não** acontece (envio, analytics, conta…)
- se houver cookies: o inventário da seção 2.1 e se a política vai **dentro** da privacidade ou em arquivo separado
- contato, licença, data

Espere o usuário dizer que está correto. Corrija o que ele negar. **Não gere os arquivos antes disso.** Confira se cada **seção obrigatória** do modo escolhido está preenchida.

## 4. Estrutura dos documentos

Os itens abaixo são **títulos de seção**, nesta ordem. O conteúdo obrigatório **preenche** a seção. Não transforme cada fato numa heading nova (`## Papel dos autores`, `## Onde o dado fica`, `## O que você pode inserir`). Se uma seção opcional não tiver fato, omita a seção inteira — não deixe o título vazio.

### Linguagem

Registro **formal e institucional**, de política jurídica brasileira. Segunda pessoa (“você”) é adequada. Não use tom de conversa, blog, README de hobby nem frase de uma linha para fechar o raciocínio.

Prefira “software” a “programa”/“app”; “oferecido de forma gratuita e para uso livre” a “de graça”; “armazenamento neste navegador” a jargão de implementação. Em português não escreva “como está” nem “AS IS”; use **sem garantia** e “oferecido sem promessa de funcionamento”.

Leia `exemplo/PRIVACIDADE.md` e `exemplo/TERMOS.md` **antes de redigir**: são o molde de abertura, ordem das seções e tom. Substitua a matéria pelos fatos confirmados. Não invente CNPJ, sede, Encarregado, mailing, grupo econômico nem coleta que o produto não tem.

### `TERMOS.md`

Abertura (sem heading): estes Termos de Uso regem a utilização do software [nome]; uso livre; inexistência de contraprestação, de SLA e de contrato de prestação de serviço. 

| Seção | O que vai dentro |
|---|---|
| **1. Natureza do software** | Ferramenta (não serviço com SLA). O que o software **não** constitui (aconselhamento, arquivo oficial, etc., só o que for verdade). O que o usuário decide sozinho (ex.: licitude de gravar conversa). |
| **2. Uso livre e propriedade intelectual** | Permissões da licença (usar, copiar, modificar, distribuir). Marcas e nomes de terceiros que o usuário inserir continuam de seus titulares. Quem publica ou hospeda cópia responde por essa cópia. |
| **3. Inteligência artificial** | *(omitir se irrelevante.)* O software envia ou não envia dados a modelo. Não misture “foi desenvolvido com IA” com tratamento dos registros do usuário. |
| **4. Ausência de garantia e de responsabilidade** | Software oferecido **sem garantia** (funcionamento, adequação a um fim, disponibilidade, segurança, ausência de erros). Autores não se responsabilizam por perda no dispositivo, conteúdo inserido, fork/hospedagem. Na máxima extensão permitida pela lei, exclusão de danos. |
| **5. Privacidade e dados** | Onde o dado fica, em uma frase. Remissão à Política de Privacidade. |
| **6. Legislação e contato** | Lei brasileira no que couber a software gratuito. Canal de contato **sem** obrigação de suporte. Data. Aviso de que o texto não constitui parecer jurídico. Foro exclusivo só se o usuário pedir. |

### `PRIVACIDADE.md`

Modo **A** se os autores não recebem o dado. Modo **B** se recebem (servidor, conta, analytics, cookie de rastreio). Não misture.

#### Modo A — autores não tratam

Abertura (sem heading), no molde de `exemplo/PRIVACIDADE.md`, em três ou quatro parágrafos:

1. Identifique o software e os autores. Oferecido de forma gratuita e para uso livre. Sem CNPJ, sede ou Encarregado, salvo se existirem de verdade.
2. A frase-eixo, adaptada ao fato de os autores **não** coletarem: *Serve o presente documento para regular, de forma simples, transparente e objetiva, como os dados pessoais são tratados no uso do software [nome], quando utilizado como distribuído.*
3. A quem se destina: quem utiliza o software no próprio dispositivo. Sem conta, sem servidor dos autores, sem envio dos registros. Cópia com servidor sai deste regime.
4. Contato: canal confirmado. Inexistindo tratamento pelos autores, não há Encarregado nem pedido de exclusão em sistema remoto.

| Seção | O que vai dentro |
|---|---|
| **Resumo** | Tabela: agente de tratamento; papel (não há controlador nem operador dos autores); natureza dos dados; finalidades; compartilhamento; proteção; direitos; transferência internacional; decisão automatizada. **Sem** linha de anonimização. |
| **Quais dados são coletados** | O que o software **não** coleta (cadastro, telemetria, etc.). O que o usuário pode inserir. Dado sensível: só se o produto pedir campo próprio; texto livre e áudio ficam como inseridos; dado de terceiro é de quem anota. Área de transferência, se houver ação explícita do usuário. |
| **Utilização dos dados** | Finalidades locais. Operações do art. 5º, X (armazenar, acessar, buscar, modificar, reproduzir, extrair, eliminar) neste dispositivo. Inexistência de coleta dos autores, perfilamento, decisão automatizada e transferência internacional. |
| **Compartilhamento** | Nenhum pelo software. Saída só por ação do usuário (exportação, cópia, sincronização do sistema). Ordem judicial sobre o dispositivo. Cópia hospedada com servidor deixa este regime. |
| **Segurança de dados** | Inexistência de transmissão pelos autores. Segurança efetiva do dispositivo. Efeitos de limpar dados do sítio, de outro navegador ou de outro aparelho. Sem compromisso de remediar incidente no aparelho do usuário. |
| **Retenção de dados** | Permanência enquanto o usuário não eliminar. Autores não conservam cópia. Sem prazo de guarda dos autores. Como eliminar (no software e no navegador). |
| **Seus direitos** | Direitos do art. 18 exercidos neste dispositivo. Cada direito, com o meio concreto ou a indicação de que não cabe (consentimento dos autores, ANPD contra os autores). Anonimização e bloqueio: não existem como função, se for o caso. |
| **Legislação aplicável e alterações** | Lei nº 13.709/2018 no que couber. Contato; inexistência de Encarregado, salvo se existir. Alterações pela publicação no repositório. Data. O texto não constitui parecer jurídico. |

#### Modo B — autores tratam

Aviso do art. 9º. Base legal **confirmada pelo usuário**.

Abertura (sem heading), no molde de `exemplo/PRIVACIDADE.md`:

1. Qualifique o controlador (nome; CNPJ e sede só se confirmados).
2. *Serve o presente documento para regular, de forma simples, transparente e objetiva, como os seus dados pessoais serão coletados, utilizados e protegidos.*
3. A quem se destina o instrumento (quem interage com o software ou com o serviço).
4. Canal para dúvidas, solicitações, incidentes e exclusão. Encarregado **somente** se existir; senão, o contato dos autores, sem inventar DPO.

| Seção | O que vai dentro |
|---|---|
| **Resumo** | Tabela equivalente à do modo A, com o controlador identificado. |
| **Quais dados são coletados** | Dados, origem, dado sensível pedido pelo software. Telemetria, pagamento, idade — só o que o produto tiver. Cookies: resumo + remissão à seção **Cookies** ou a `COOKIES.md`. |
| **Cookies** | *(omitir se não houver.)* Inventário da seção 2.1, no molde de `exemplo/COOKIES.txt`. Se o usuário pediu arquivo separado, aqui só a remissão. |
| **Utilização dos dados** | Finalidade específica (art. 9º, I). Forma e duração (art. 9º, II). Base legal (arts. 7º e 11); sem “ao utilizar, você consente”. Interesse legítimo, se essa for a base. |
| **Compartilhamento** | Destinatários e finalidade (art. 9º, V), ou a inexistência. Transferência internacional. Operador, se existir (art. 9º, VI). Cópia hospedada por terceiro. |
| **Segurança de dados** | Medidas que de fato existem. |
| **Retenção de dados** | Critério real de guarda e exclusão. |
| **Seus direitos** | Art. 18 um a um, com canal para exercer (art. 9º, VII). Decisão automatizada (art. 20), se houver. Encarregado, só se existir. |
| **Legislação aplicável e alterações** | Como no modo A, com o contato do controlador. |

## 5. Redigir

Arquivos de texto na raiz do projeto (ou onde o usuário pedir): `PRIVACIDADE.md` e `TERMOS.md`. Siga a estrutura da seção 4, o registro de `exemplo/` e o quadro de fatos. Data: hoje, salvo outro combinado. `COOKIES.md` só na hipótese da seção 2.1.

Não gere sítio, rota, HTML nem implantação, salvo se o usuário pedir depois. Ao terminar, informe que os `.md` são o original e que **publicar o endereço** (em geral HTML no servidor) cabe ao usuário.

Não use detalhe técnico da implementação: localStorage, SQL, Postgres, Redis, key-value, IndexedDB, nome de biblioteca. Diga “neste navegador”, “no seu aparelho”, “em servidor dos autores”. Exceção: o **nome do cookie** no inventário da seção 2.1. Não funda os dois arquivos. Não apresente o Termo de Uso como exigência da LGPD.
