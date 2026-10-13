# Legal BR - Converte a biblioteca de fontes para markdown.
#
# Le fontes/ e escreve fontes-md/. Nao altera nada em fontes/.
#
# Cada conversao passa por Test-Conversao antes de ser gravada: contagem de
# artigos, paragrafos, revogacoes e notas de redacao tem que bater com a origem.
# Reprovou, o .md nao e escrito e o motivo aparece no relatorio. Conversao
# silenciosamente incompleta e o pior modo de falha aqui.

$ErrorActionPreference = 'Continue'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

. (Join-Path $Root 'lib-conversao.ps1')

$catalogoPath = Join-Path $Root 'fontes-oficiais.json'
$destinoRaiz  = Join-Path $Root 'fontes-md'

if (-not (Test-Path $catalogoPath)) {
    Write-Host "Erro: fontes-oficiais.json nao encontrado em $Root" -ForegroundColor Red
    exit 2
}

$catalogo = Get-Content $catalogoPath -Raw -Encoding UTF8 | ConvertFrom-Json

$temPdftotext = [bool](Get-Command pdftotext -ErrorAction SilentlyContinue)
if (-not $temPdftotext) {
    Write-Host 'AVISO: pdftotext nao encontrado. Os PDFs da ANPD ficam sem versao markdown.' -ForegroundColor DarkYellow
    Write-Host '       Eles continuam legiveis: Claude e ChatGPT abrem PDF nativamente.' -ForegroundColor DarkYellow
    Write-Host '       Para habilitar, instale o Git for Windows ou o poppler-utils.' -ForegroundColor DarkYellow
    Write-Host ''
}

$convertidos = 0
$reprovados  = @()
$pulados     = @()
$ausentes    = @()
$i = 0

foreach ($fonte in $catalogo) {
    $i++
    $origem = Join-Path $Root "fontes\$($fonte.categoria)\$($fonte.arquivo)"
    $nomeMd = [System.IO.Path]::GetFileNameWithoutExtension($fonte.arquivo) + '.md'
    $pastaMd = Join-Path $destinoRaiz $fonte.categoria
    $destino = Join-Path $pastaMd $nomeMd
    $relOrigem = "fontes/$($fonte.categoria)/$($fonte.arquivo)"

    Write-Host ("[{0}/{1}] {2}" -f $i, $catalogo.Count, $fonte.titulo) -ForegroundColor Cyan

    if (-not (Test-Path $origem)) {
        Write-Host '        AUSENTE na biblioteca local' -ForegroundColor Red
        $ausentes += $fonte.titulo
        continue
    }

    if (-not (Test-Path $pastaMd)) { New-Item -ItemType Directory -Path $pastaMd -Force | Out-Null }

    if ($fonte.arquivo -match '\.pdf$') {
        $md = ConvertTo-MarkdownPdf -CaminhoPdf $origem -Titulo $fonte.titulo -Url $fonte.url -ArquivoOrigem $relOrigem
        if (-not $md) {
            Write-Host '        PULADO (sem pdftotext ou extracao vazia)' -ForegroundColor DarkYellow
            $pulados += $fonte.titulo
            continue
        }
        $md | Set-Content -Path $destino -Encoding UTF8
        $kb = [math]::Round((Get-Item $destino).Length / 1KB)
        Write-Host "        OK  fontes-md/$($fonte.categoria)/$nomeMd ($kb KB)" -ForegroundColor Green
        $convertidos++
        continue
    }

    $html   = Read-Fonte -Caminho $origem
    $plano  = Get-TextoPlano -Html $html
    $md     = ConvertTo-MarkdownFonte -Html $html -Titulo $fonte.titulo -Url $fonte.url -ArquivoOrigem $relOrigem

    $problemas = Test-Conversao -TextoOrigem $plano -Markdown $md
    if ($problemas.Count -gt 0) {
        Write-Host '        REPROVADO na verificacao, markdown nao gravado' -ForegroundColor Red
        foreach ($p in $problemas) { Write-Host "          $p" -ForegroundColor Red }
        $reprovados += [PSCustomObject]@{ Titulo = $fonte.titulo; Problemas = $problemas }
        continue
    }

    $md | Set-Content -Path $destino -Encoding UTF8
    $kbOrig = [math]::Round((Get-Item $origem).Length / 1KB)
    $kbMd   = [math]::Round((Get-Item $destino).Length / 1KB)
    Write-Host "        OK  fontes-md/$($fonte.categoria)/$nomeMd ($kbOrig KB -> $kbMd KB)" -ForegroundColor Green
    $convertidos++
}

Write-Host ''
Write-Host 'Legal BR - conversao concluida' -ForegroundColor Yellow
Write-Host "Convertidos: $convertidos   Reprovados: $($reprovados.Count)   Pulados: $($pulados.Count)   Ausentes: $($ausentes.Count)"

if ($reprovados.Count -gt 0) {
    Write-Host ''
    Write-Host 'Reprovados na verificacao (o markdown nao foi gravado):' -ForegroundColor Red
    foreach ($r in $reprovados) {
        Write-Host "  $($r.Titulo)" -ForegroundColor Red
        foreach ($p in $r.Problemas) { Write-Host "    $p" }
    }
    Write-Host ''
    Write-Host 'Use o arquivo original destas normas. O markdown ausente e proposital.' -ForegroundColor Red
}

if (($reprovados.Count + $ausentes.Count) -gt 0) { exit 1 } else { exit 0 }
