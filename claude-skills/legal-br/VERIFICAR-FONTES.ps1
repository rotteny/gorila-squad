# Legal BR - Verificador de atualidade das fontes oficiais
#
# Somente leitura. Nao altera nada dentro de fontes/.
#
# Baixa cada fonte para area temporaria, compara o hash de CONTEUDO com o
# registrado em CONTEUDO-SHA256.txt e informa o que mudou desde a ultima coleta.
# Compara conteudo, e nao bytes, porque o balanceador do Planalto injeta um
# script com token aleatorio a cada requisicao: por bytes, ate a Constituicao
# apareceria alterada varias vezes ao dia.
#
# Para atualizar de fato, use ATUALIZAR-FONTES.bat.

$ErrorActionPreference = 'Continue'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

. (Join-Path $Root 'lib-fontes.ps1')

$catalogoPath = Join-Path $Root 'fontes-oficiais.json'
$conteudoPath = Join-Path $Root 'CONTEUDO-SHA256.txt'
$ultimaPath   = Join-Path $Root 'ULTIMA-ATUALIZACAO.txt'
$statusPath   = Join-Path $Root 'STATUS-FONTES.md'

if (-not (Test-Path $catalogoPath)) {
    Write-Host "Erro: fontes-oficiais.json nao encontrado em $Root" -ForegroundColor Red
    exit 2
}
if (-not (Test-Path $conteudoPath)) {
    Write-Host "Erro: CONTEUDO-SHA256.txt nao encontrado. Rode ATUALIZAR-FONTES.bat uma vez." -ForegroundColor Red
    exit 2
}

$catalogo    = Get-Content $catalogoPath -Raw -Encoding UTF8 | ConvertFrom-Json
$registrados = Read-Hashes -Caminho $conteudoPath

$idadeDias = $null
if (Test-Path $ultimaPath) {
    $txt = Get-Content $ultimaPath -Raw -Encoding UTF8
    if ($txt -match '(\d{4}-\d{2}-\d{2})') {
        $coleta = [datetime]::ParseExact($matches[1], 'yyyy-MM-dd', $null)
        $idadeDias = [int]((Get-Date) - $coleta).TotalDays
    }
}

$headers = @{
    'User-Agent'      = 'Mozilla/5.0 LegalBR-Reference-Checker/1.0'
    'Accept-Language' = 'pt-BR,pt;q=0.9,en;q=0.5'
}

$resultados = @()
$i = 0

foreach ($fonte in $catalogo) {
    $i++
    $rel  = "fontes/$($fonte.categoria)/$($fonte.arquivo)"
    $temp = Join-Path $env:TEMP "legalbr-check-$($fonte.arquivo)"

    Write-Host ("[{0}/{1}] {2}" -f $i, $catalogo.Count, $fonte.titulo) -ForegroundColor Cyan

    $situacao = ''
    $detalhe  = ''

    try {
        Invoke-WebRequest -Uri $fonte.url -OutFile $temp -Headers $headers -UseBasicParsing -MaximumRedirection 10 -ErrorAction Stop

        $problema = Test-Download -Caminho $temp -Nome $fonte.arquivo
        if ($problema) {
            $situacao = 'INACESSIVEL'
            $detalhe  = $problema
        }
        else {
            $atual = Get-HashConteudo -Caminho $temp -Nome $fonte.arquivo
            if (-not $registrados.ContainsKey($rel)) {
                $situacao = 'SEM REGISTRO'
                $detalhe  = 'nao consta em CONTEUDO-SHA256.txt'
            }
            elseif ($atual -eq $registrados[$rel]) {
                $situacao = 'EM DIA'
            }
            elseif ($fonte.prioridade -eq 'essencial-dinamica') {
                $situacao = 'MUDOU (dinamica)'
                $detalhe  = 'pagina de listagem, muda a cada publicacao nova'
            }
            else {
                $situacao = 'MUDOU'
                $detalhe  = 'texto diferente do snapshot local'
            }
        }
    }
    catch {
        $situacao = 'INACESSIVEL'
        $detalhe  = $_.Exception.Message
    }
    finally {
        Remove-Item $temp -Force -ErrorAction SilentlyContinue
    }

    $cor = 'Red'
    if ($situacao -eq 'EM DIA')             { $cor = 'Green' }
    elseif ($situacao -eq 'MUDOU')          { $cor = 'Yellow' }
    elseif ($situacao -like 'MUDOU (din*')  { $cor = 'DarkYellow' }
    Write-Host "        $situacao $detalhe" -ForegroundColor $cor

    $resultados += [PSCustomObject]@{
        Titulo     = $fonte.titulo
        Arquivo    = $rel
        Url        = $fonte.url
        Prioridade = $fonte.prioridade
        Situacao   = $situacao
        Detalhe    = $detalhe
    }
}

$emDia       = @($resultados | Where-Object { $_.Situacao -eq 'EM DIA' }).Count
$mudou       = @($resultados | Where-Object { $_.Situacao -eq 'MUDOU' }).Count
$mudouDin    = @($resultados | Where-Object { $_.Situacao -eq 'MUDOU (dinamica)' }).Count
$inacessivel = @($resultados | Where-Object { $_.Situacao -eq 'INACESSIVEL' }).Count
$semRegistro = @($resultados | Where-Object { $_.Situacao -eq 'SEM REGISTRO' }).Count

$agora  = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'
$linhas = New-Object System.Collections.Generic.List[string]

$linhas.Add('# Status das fontes oficiais')
$linhas.Add('')
$linhas.Add("Verificado em $agora.")
if ($null -ne $idadeDias) { $linhas.Add("Snapshot local coletado ha $idadeDias dia(s).") }
$linhas.Add('')

if ($mudou -eq 0 -and $inacessivel -eq 0 -and $semRegistro -eq 0) {
    $linhas.Add('**Todas as normas conferidas batem com a fonte oficial.** A biblioteca local pode ser usada como texto vigente.')
}
else {
    $linhas.Add('**Ha fontes que nao batem com o original.** Veja abaixo antes de usar a copia local como texto vigente.')
}
$linhas.Add('')
$linhas.Add('| Situacao | Fontes |')
$linhas.Add('|---|---|')
$linhas.Add("| Em dia | $emDia |")
$linhas.Add("| Mudou | $mudou |")
$linhas.Add("| Mudou (pagina dinamica) | $mudouDin |")
$linhas.Add("| Inacessivel | $inacessivel |")
$linhas.Add("| Sem registro | $semRegistro |")
$linhas.Add('')

if ($mudou -gt 0) {
    $linhas.Add('## Desatualizadas')
    $linhas.Add('')
    $linhas.Add('O texto local difere da fonte oficial. Nao trate estes arquivos como vigentes: consulte a fonte online antes de concluir, e trate o ponto como PENDENCIA DE VALIDACAO se nao conseguir confirmar.')
    $linhas.Add('')
    $linhas.Add('| Norma | Arquivo local | Fonte oficial |')
    $linhas.Add('|---|---|---|')
    foreach ($r in ($resultados | Where-Object { $_.Situacao -eq 'MUDOU' })) {
        $linhas.Add("| $($r.Titulo) | ``$($r.Arquivo)`` | $($r.Url) |")
    }
    $linhas.Add('')
}

if ($inacessivel -gt 0) {
    $linhas.Add('## Inacessiveis')
    $linhas.Add('')
    $linhas.Add('Nao foi possivel verificar. A copia local pode estar correta ou nao, e a duvida precisa aparecer na analise.')
    $linhas.Add('')
    $linhas.Add('| Norma | Motivo |')
    $linhas.Add('|---|---|')
    foreach ($r in ($resultados | Where-Object { $_.Situacao -eq 'INACESSIVEL' })) {
        $linhas.Add("| $($r.Titulo) | $($r.Detalhe) |")
    }
    $linhas.Add('')
}

if ($mudouDin -gt 0) {
    $linhas.Add('## Paginas dinamicas')
    $linhas.Add('')
    $linhas.Add('Paginas de listagem da ANPD. Mudam a cada publicacao nova, entao a diferenca e esperada e nao indica alteracao normativa. Vale abrir para ver se saiu guia ou resolucao nova que ainda nao esta no catalogo.')
    $linhas.Add('')
    foreach ($r in ($resultados | Where-Object { $_.Situacao -eq 'MUDOU (dinamica)' })) {
        $linhas.Add("- $($r.Titulo)")
        $linhas.Add("  $($r.Url)")
    }
    $linhas.Add('')
}

$linhas.Add('## Detalhe completo')
$linhas.Add('')
$linhas.Add('| Norma | Prioridade | Situacao |')
$linhas.Add('|---|---|---|')
foreach ($r in $resultados) {
    $linhas.Add("| $($r.Titulo) | $($r.Prioridade) | $($r.Situacao) |")
}
$linhas.Add('')
$linhas.Add('Para atualizar a biblioteca local, execute ATUALIZAR-FONTES.bat.')
$linhas.Add('')
$linhas.Add('Arquivo gerado por VERIFICAR-FONTES.ps1. Nao edite a mao.')

$linhas | Set-Content -Path $statusPath -Encoding UTF8

Write-Host ''
Write-Host 'Legal BR - verificacao concluida' -ForegroundColor Yellow
Write-Host "Em dia: $emDia   Mudou: $mudou   Dinamicas: $mudouDin   Inacessiveis: $inacessivel   Sem registro: $semRegistro"
Write-Host 'Relatorio: STATUS-FONTES.md'

if (($mudou + $inacessivel + $semRegistro) -gt 0) { exit 1 } else { exit 0 }
