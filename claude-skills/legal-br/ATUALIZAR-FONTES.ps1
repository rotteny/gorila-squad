# Legal BR - Atualizador de Fontes Oficiais
# Catálogo criado em 2026-08-09.

$ErrorActionPreference = 'Continue'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$Fontes = @(
    [PSCustomObject]@{ Titulo = 'Constituição da República Federativa do Brasil'; Url = 'https://www.planalto.gov.br/ccivil_03/constituicao/constituicao.htm'; Caminho = 'fontes/leis/00-constituicao-federal.html' },
    [PSCustomObject]@{ Titulo = 'Código Civil - Lei nº 10.406/2002 (texto compilado)'; Url = 'https://www.planalto.gov.br/ccivil_03/leis/2002/l10406compilada.htm'; Caminho = 'fontes/leis/01-codigo-civil-lei-10406-2002-compilada.html' },
    [PSCustomObject]@{ Titulo = 'Código de Defesa do Consumidor - Lei nº 8.078/1990 (texto compilado)'; Url = 'https://www.planalto.gov.br/ccivil_03/leis/l8078compilado.htm'; Caminho = 'fontes/leis/02-cdc-lei-8078-1990-compilado.html' },
    [PSCustomObject]@{ Titulo = 'Lei Geral de Proteção de Dados - Lei nº 13.709/2018 (texto compilado)'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709compilado.htm'; Caminho = 'fontes/leis/03-lgpd-lei-13709-2018-compilado.html' },
    [PSCustomObject]@{ Titulo = 'Marco Civil da Internet - Lei nº 12.965/2014'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2014/lei/l12965.htm'; Caminho = 'fontes/leis/04-marco-civil-internet-lei-12965-2014.html' },
    [PSCustomObject]@{ Titulo = 'Decreto do Comércio Eletrônico - Decreto nº 7.962/2013'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2013/decreto/d7962.htm'; Caminho = 'fontes/leis/05-comercio-eletronico-decreto-7962-2013.html' },
    [PSCustomObject]@{ Titulo = 'Lei de Software - Lei nº 9.609/1998'; Url = 'https://www.planalto.gov.br/ccivil_03/leis/l9609.htm'; Caminho = 'fontes/leis/06-lei-software-9609-1998.html' },
    [PSCustomObject]@{ Titulo = 'Lei de Direitos Autorais - Lei nº 9.610/1998'; Url = 'https://www.planalto.gov.br/ccivil_03/leis/l9610.htm'; Caminho = 'fontes/leis/07-direitos-autorais-9610-1998.html' },
    [PSCustomObject]@{ Titulo = 'Estatuto da Criança e do Adolescente - Lei nº 8.069/1990'; Url = 'https://www.planalto.gov.br/ccivil_03/leis/l8069.htm'; Caminho = 'fontes/leis/08-eca-lei-8069-1990.html' },
    [PSCustomObject]@{ Titulo = 'Lei Geral do Esporte - Lei nº 14.597/2023'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2023/lei/l14597.htm'; Caminho = 'fontes/leis/09-lei-geral-esporte-14597-2023.html' },
    [PSCustomObject]@{ Titulo = 'Assinaturas Eletrônicas - Lei nº 14.063/2020'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2019-2022/2020/lei/l14063.htm'; Caminho = 'fontes/leis/10-assinaturas-eletronicas-14063-2020.html' },
    [PSCustomObject]@{ Titulo = 'ICP-Brasil - Medida Provisória nº 2.200-2/2001'; Url = 'https://www.planalto.gov.br/ccivil_03/mpv/antigas_2001/2200-2.htm'; Caminho = 'fontes/leis/11-icp-brasil-mp-2200-2-2001.html' },
    [PSCustomObject]@{ Titulo = 'ECA Digital - Lei nº 15.211/2025'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm'; Caminho = 'fontes/eca-digital/20-eca-digital-lei-15211-2025.html' },
    [PSCustomObject]@{ Titulo = 'Regulamentação do ECA Digital - Decreto nº 12.880/2026'; Url = 'https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2026/decreto/d12880.htm'; Caminho = 'fontes/eca-digital/21-eca-digital-decreto-12880-2026.html' },
    [PSCustomObject]@{ Titulo = 'ANPD - página oficial do ECA Digital'; Url = 'https://www.gov.br/anpd/pt-br/assuntos/eca-digital'; Caminho = 'fontes/eca-digital/22-anpd-eca-digital-pagina-atual.html' },
    [PSCustomObject]@{ Titulo = 'ANPD - orientações sobre aferição de idade no ambiente digital'; Url = 'https://www.gov.br/anpd/pt-br/assuntos/noticias/anpd-publica-orientacoes-preliminares-e-cronograma-para-afericao-de-idade-no-ambiente-digital'; Caminho = 'fontes/eca-digital/23-anpd-afericao-idade-orientacoes-2026.html' },
    [PSCustomObject]@{ Titulo = 'ANPD - Guia: Hipóteses legais de tratamento - Legítimo Interesse'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/copy_of_guia_legitimo_interesse.pdf/@@display-file/file'; Caminho = 'fontes/anpd/30-guia-legitimo-interesse.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Guia Orientativo Cookies e Proteção de Dados Pessoais'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-cookies-e-protecao-de-dados-pessoais.pdf/@@display-file/file'; Caminho = 'fontes/anpd/31-guia-cookies.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Guia: Definições dos Agentes de Tratamento e do Encarregado'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_agentes_de_tratamento_e_encarregado___defeso_eleitoral.pdf/@@display-file/file'; Caminho = 'fontes/anpd/32-guia-agentes-tratamento-encarregado.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Guia de Segurança da Informação para Agentes de Tratamento de Pequeno Porte'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_seguranca_da_informacao_para_atpps___defeso_eleitoral.pdf/@@display-file/file'; Caminho = 'fontes/anpd/33-guia-seguranca-pequeno-porte.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Checklist de medidas de segurança para agentes de pequeno porte'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/checklist-vf.pdf/@@display-file/file'; Caminho = 'fontes/anpd/34-checklist-seguranca-pequeno-porte.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Modelo de Registro das Operações de Tratamento (ROPA) para ATPP'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/modelo_de_ropa_para_atpp.pdf/@@display-file/file'; Caminho = 'fontes/anpd/35-modelo-ropa-atpp.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Guia: Atuação do Encarregado pelo Tratamento de Dados Pessoais'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia_da_atuacao_do_encarregado_anpd.pdf/@@display-file/file'; Caminho = 'fontes/anpd/36-guia-atuacao-encarregado.pdf' },
    [PSCustomObject]@{ Titulo = 'ANPD - Central de Materiais Educativos e Publicações'; Url = 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes'; Caminho = 'fontes/anpd/37-anpd-materiais-publicacoes.html' },
    [PSCustomObject]@{ Titulo = 'ANPD - Regulamentações vigentes'; Url = 'https://www.gov.br/anpd/pt-br/acesso-a-informacao/institucional/atos-normativos/regulamentacoes_anpd'; Caminho = 'fontes/anpd/38-anpd-regulamentacoes.html' },
    [PSCustomObject]@{ Titulo = 'Resolução CD/ANPD nº 2/2022 - agentes de tratamento de pequeno porte'; Url = 'https://www.gov.br/anpd/pt-br/acesso-a-informacao/institucional/atos-normativos/regulamentacoes_anpd/resolucao-cd-anpd-no-2-de-27-de-janeiro-de-2022'; Caminho = 'fontes/anpd/39-resolucao-anpd-2-2022-pequeno-porte.html' },
    [PSCustomObject]@{ Titulo = 'Resolução CD/ANPD nº 18/2024 - atuação do encarregado (DOU)'; Url = 'https://www.in.gov.br/en/web/dou/-/resolucao-cd/anpd-n-18-de-16-de-julho-de-2024-572632074'; Caminho = 'fontes/anpd/40-resolucao-anpd-18-2024-encarregado.html' },
    [PSCustomObject]@{ Titulo = 'Resolução CD/ANPD nº 15/2024 - comunicação de incidente de segurança (DOU)'; Url = 'https://www.in.gov.br/en/web/dou/-/resolucao-cd/anpd-n-15-de-24-de-abril-de-2024-556243024'; Caminho = 'fontes/anpd/41-resolucao-anpd-15-2024-incidentes.html' },
    [PSCustomObject]@{ Titulo = 'Resolução CD/ANPD nº 19/2024 - transferência internacional de dados'; Url = 'https://www.gov.br/anpd/pt-br/acesso-a-informacao/institucional/atos-normativos/regulamentacoes_anpd/resolucao-cd-anpd-no-19-de-23-de-agosto-de-2024'; Caminho = 'fontes/anpd/42-resolucao-anpd-19-2024-transferencia-internacional.html' }
)

$headers = @{
    'User-Agent' = 'Mozilla/5.0 LegalBR-Reference-Updater/1.0'
    'Accept-Language' = 'pt-BR,pt;q=0.9,en;q=0.5'
}

# Funcoes comuns: validacao de download e hash de conteudo.
. (Join-Path $Root 'lib-fontes.ps1')


$sucesso = 0
$falhas = @()

foreach ($fonte in $Fontes) {
    $destino = Join-Path $Root $fonte.Caminho
    $pasta = Split-Path -Parent $destino
    if (-not (Test-Path $pasta)) {
        New-Item -ItemType Directory -Path $pasta -Force | Out-Null
    }
    $temporario = "$destino.download"

    Write-Host ""
    Write-Host "Baixando: $($fonte.Titulo)" -ForegroundColor Cyan

    try {
        # Baixa para arquivo temporario: uma falha nunca destroi a copia boa anterior.
        Invoke-WebRequest -Uri $fonte.Url -OutFile $temporario -Headers $headers -UseBasicParsing -MaximumRedirection 10 -ErrorAction Stop

        $problema = Test-Download -Caminho $temporario
        if ($problema) {
            Remove-Item $temporario -Force -ErrorAction SilentlyContinue
            Write-Host "INVALIDO -> $problema" -ForegroundColor Red
            $falhas += "$($fonte.Titulo)`t$($fonte.Url)`t$problema"
        }
        else {
            Move-Item -Path $temporario -Destination $destino -Force
            $kb = [math]::Round((Get-Item $destino).Length / 1KB)
            Write-Host "OK -> $($fonte.Caminho) ($kb KB)" -ForegroundColor Green
            $sucesso++
        }
    }
    catch {
        Remove-Item $temporario -Force -ErrorAction SilentlyContinue
        Write-Host "FALHA -> $($fonte.Url)" -ForegroundColor Red
        $falhas += "$($fonte.Titulo)`t$($fonte.Url)`t$($_.Exception.Message)"
    }
}

$hashFile = Join-Path $Root "CHECKSUMS-SHA256.txt"
$arquivos = Get-ChildItem (Join-Path $Root "fontes") -File -Recurse -ErrorAction SilentlyContinue
$hashes = foreach ($arq in $arquivos) {
    try {
        $hash = Get-FileHash $arq.FullName -Algorithm SHA256
        $rel = $arq.FullName.Substring($Root.Length).TrimStart('\','/')
        "$($hash.Hash)  $rel"
    } catch {}
}
$hashes | Set-Content -Path $hashFile -Encoding UTF8

# Hash do conteudo: ignora o <script id="f5_cspm"> que o balanceador do Planalto
# injeta a cada requisicao. E este arquivo que o VERIFICAR-FONTES.ps1 compara.
$conteudoFile = Join-Path $Root "CONTEUDO-SHA256.txt"
$errosHash = @()
$conteudos = foreach ($arq in $arquivos) {
    if ($arq.Name -eq '.gitkeep') { continue }
    try {
        $h = Get-HashConteudo -Caminho $arq.FullName -Nome $arq.Name
        $rel = $arq.FullName.Substring($Root.Length).TrimStart([char]92, [char]47).Replace([char]92, [char]47)
        "$h  $rel"
    }
    catch {
        $errosHash += "$($arq.Name): $($_.Exception.Message)"
    }
}
if ($errosHash.Count -gt 0) {
    Write-Host "AVISO: $($errosHash.Count) arquivo(s) sem hash de conteudo:" -ForegroundColor Red
    $errosHash | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
}
if (-not $conteudos -or $conteudos.Count -eq 0) {
    Write-Host "ERRO: nenhum hash de conteudo foi gerado. CONTEUDO-SHA256.txt nao sera escrito." -ForegroundColor Red
}
else {
    $conteudos | Set-Content -Path $conteudoFile -Encoding UTF8
    Write-Host "CONTEUDO-SHA256.txt: $($conteudos.Count) arquivos" -ForegroundColor Green
}


$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss K"
@(
    "Última execução: $timestamp"
    "Downloads concluídos: $sucesso / $($Fontes.Count)"
    "Falhas: $($falhas.Count)"
) | Set-Content -Path (Join-Path $Root "ULTIMA-ATUALIZACAO.txt") -Encoding UTF8

if ($falhas.Count -gt 0) {
    $falhas | Set-Content -Path (Join-Path $Root "FALHAS-DOWNLOAD.txt") -Encoding UTF8
} elseif (Test-Path (Join-Path $Root "FALHAS-DOWNLOAD.txt")) {
    Remove-Item (Join-Path $Root "FALHAS-DOWNLOAD.txt") -Force
}

# Converte para markdown. A verificacao de perda esta dentro do conversor:
# arquivo que nao passa nao e gravado, e a norma continua legivel no original.
$conversor = Join-Path $Root 'CONVERTER-FONTES.ps1'
$conversaoOk = $true
if (Test-Path $conversor) {
    Write-Host ""
    Write-Host "Convertendo a biblioteca para markdown..." -ForegroundColor Cyan
    Write-Host ""
    & $conversor
    if ($LASTEXITCODE -ne 0) { $conversaoOk = $false }
}
else {
    Write-Host "AVISO: CONVERTER-FONTES.ps1 nao encontrado. fontes-md/ nao foi atualizada." -ForegroundColor DarkYellow
    $conversaoOk = $false
}

Write-Host ""
Write-Host "Legal BR - atualização concluída" -ForegroundColor Yellow
Write-Host "Downloads: $sucesso / $($Fontes.Count)"
Write-Host "Falhas: $($falhas.Count)"
if ($falhas.Count -gt 0) {
    Write-Host "Veja FALHAS-DOWNLOAD.txt para baixar manualmente os itens bloqueados." -ForegroundColor Yellow
}
if (-not $conversaoOk) {
    Write-Host "Houve norma sem versão markdown. Use o arquivo original dessas." -ForegroundColor Yellow
}
