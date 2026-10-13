# VALIDAR-REVISAO.ps1
# Confere a parte mecanica de um documento revisado pela skill legal-br.
#
# Nao avalia merito juridico. Checa contagem, consistencia interna, formato
# e presenca dos elementos que a regra de evidencia exige.
#
# Uso:  .\VALIDAR-REVISAO.ps1 <arquivo-REVISADO.md> [-Original <arquivo-original.md>]
# Saida: relatorio no console. Exit code 0 = aprovado, 1 = reprovado.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Arquivo,

    [Parameter(Mandatory = $false)]
    [string]$Original
)

$ErrorActionPreference = 'Stop'

$script:Falhas = 0
$script:Avisos = 0
$script:Passou = 0

function Write-Titulo($texto) {
    Write-Host ""
    Write-Host "== $texto" -ForegroundColor Cyan
}

function Get-Secao($linhas, $inicio, $fim) {
    $i = ($linhas | Select-String -SimpleMatch $inicio | Select-Object -First 1).LineNumber
    if ($null -eq $i) { return @() }
    $f = ($linhas | Select-String -SimpleMatch $fim | Select-Object -First 1).LineNumber
    if ($null -eq $f -or $f -le $i) { $f = $linhas.Count }
    return $linhas[($i - 1)..($f - 2)]
}

function Test-Item {
    param(
        [string]$Nome,
        [bool]$Condicao,
        [string]$Detalhe = '',
        [switch]$Aviso
    )
    if ($Condicao) {
        Write-Host "  OK      $Nome" -ForegroundColor Green
        $script:Passou++
    }
    elseif ($Aviso) {
        $msg = "  AVISO   $Nome"
        if ($Detalhe) { $msg += " -> $Detalhe" }
        Write-Host $msg -ForegroundColor Yellow
        $script:Avisos++
    }
    else {
        $msg = "  FALHA   $Nome"
        if ($Detalhe) { $msg += " -> $Detalhe" }
        Write-Host $msg -ForegroundColor Red
        $script:Falhas++
    }
}

# ---------------------------------------------------------------- carregamento

if (-not (Test-Path -LiteralPath $Arquivo)) {
    Write-Host "Arquivo nao encontrado: $Arquivo" -ForegroundColor Red
    exit 1
}

$texto = Get-Content -LiteralPath $Arquivo -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($texto)) {
    Write-Host "Arquivo vazio: $Arquivo" -ForegroundColor Red
    exit 1
}
$linhas = $texto -split "`r?`n"
$nomeArquivo = Split-Path -Leaf $Arquivo

Write-Host ""
Write-Host "Validando: $nomeArquivo" -ForegroundColor White
Write-Host ("-" * 70)

# ------------------------------------------------------------------ 1. formato

Write-Titulo "Nome e estrutura"

Test-Item -Nome "Nome segue <original>-REVISADO-AAAA-MM-DD.md" `
    -Condicao ($nomeArquivo -match '-REVISADO-\d{4}-\d{2}-\d{2}\.md$') `
    -Detalhe $nomeArquivo

$secoesEsperadas = @(
    '## 1. Resumo executivo',
    '## 2. Contexto e premissas',
    '## 3. An',
    '## 4. Cl',
    '## 5. Campos a preencher',
    '## 6. Requisitos para implementa',
    '## 7. Pend',
    '## 8. Fontes verificadas',
    '## 9. Documento revisado'
)
foreach ($sec in $secoesEsperadas) {
    $achou = $linhas | Where-Object { $_ -like "$sec*" }
    Test-Item -Nome "Secao presente: $sec" -Condicao ($null -ne $achou)
}

# ---------------------------------------------------------------- 2. clausulas

Write-Titulo "Analise clausula a clausula"

# Corta o texto na secao 9 para nao confundir o texto consolidado com a analise
$idxSecao9 = ($linhas | Select-String -SimpleMatch '## 9. Documento revisado' | Select-Object -First 1).LineNumber
if ($null -eq $idxSecao9) { $idxSecao9 = $linhas.Count }
$analise = $linhas[0..($idxSecao9 - 1)]

$cabecalhos = @($analise | Where-Object { $_ -match '^###\s+(Cl.usula|Se..o|Artigo|Item)\s' })
$qtdClausulas = $cabecalhos.Count

Test-Item -Nome "Ha pelo menos uma clausula analisada" -Condicao ($qtdClausulas -gt 0) `
    -Detalhe "encontradas: $qtdClausulas"

if ($Original) {
    if (Test-Path -LiteralPath $Original) {
        $txtOrig = Get-Content -LiteralPath $Original -Raw -Encoding UTF8
        $origClausulas = ([regex]::Matches($txtOrig, '(?m)^##\s+((Cl.usula|Se..o|Artigo|Item)\s|\d+\s*[\.\-])')).Count
        Test-Item -Nome "Cobertura: analisou todas as clausulas do original" `
            -Condicao ($qtdClausulas -eq $origClausulas) `
            -Detalhe "original=$origClausulas revisao=$qtdClausulas"
    }
    else {
        Test-Item -Nome "Arquivo original informado existe" -Condicao $false -Detalhe $Original
    }
}
else {
    Write-Host "  AVISO   Cobertura nao verificada -> passe -Original para conferir" -ForegroundColor Yellow
    $script:Avisos++
}

# Quebra a analise em blocos por clausula
$blocos = @()
$idxCab = @()
for ($i = 0; $i -lt $analise.Count; $i++) {
    if ($analise[$i] -match '^###\s+(Cl.usula|Se..o|Artigo|Item)\s') { $idxCab += $i }
}
for ($j = 0; $j -lt $idxCab.Count; $j++) {
    $ini = $idxCab[$j]
    if ($j -lt $idxCab.Count - 1) { $fim = $idxCab[$j + 1] - 1 } else { $fim = $analise.Count - 1 }
    $blocos += , @{
        Titulo = $analise[$ini].Trim()
        Texto  = ($analise[$ini..$fim] -join "`n")
    }
}

$semClassificacao = @()
$semRisco = @()
$semFundamento = @()
$semRedacao = @()
$semIncidencia = @()

foreach ($b in $blocos) {
    if ($b.Texto -notmatch '\*\*Classifica..o:\*\*') { $semClassificacao += $b.Titulo }
    if ($b.Texto -notmatch '\*\*Risco:\*\*') { $semRisco += $b.Titulo }

    $semApontamento = $b.Texto -match 'Sem apontamento'
    if (-not $semApontamento) {
        if ($b.Texto -notmatch '\*\*Fundamento\*\*') { $semFundamento += $b.Titulo }
        if ($b.Texto -notmatch '\*\*Reda..o proposta\*\*') { $semRedacao += $b.Titulo }
    }
    # Incidencia nivel 2: exigida quando o bloco cita norma com escopo proprio.
    # Marcadores de escopo restritivo no texto transcrito do dispositivo.
    $temEscopoRestrito = $b.Texto -match 'para os fins desta Lei|consideram-se|aplica-se a|desde que'
    if ($temEscopoRestrito -and -not $semApontamento) {
        if ($b.Texto -notmatch 'Incid.ncia|alcan.a|n.o se aplica|se aplica|enquadr|delimit|restring') {
            $semIncidencia += $b.Titulo
        }
    }
}

Test-Item -Nome "Toda clausula tem Classificacao" -Condicao ($semClassificacao.Count -eq 0) `
    -Detalhe ($semClassificacao -join '; ')
Test-Item -Nome "Toda clausula tem Risco" -Condicao ($semRisco.Count -eq 0) `
    -Detalhe ($semRisco -join '; ')
Test-Item -Nome "Toda clausula com problema tem Fundamento" -Condicao ($semFundamento.Count -eq 0) `
    -Detalhe ($semFundamento -join '; ')
Test-Item -Nome "Toda clausula com problema tem Redacao proposta" -Condicao ($semRedacao.Count -eq 0) `
    -Detalhe ($semRedacao -join '; ')
Test-Item -Nome "Norma com escopo proprio tem incidencia argumentada" -Condicao ($semIncidencia.Count -eq 0) `
    -Detalhe ($semIncidencia -join '; ')

# Nivel 1: premissas de incidencia declaradas na secao 2
$secCtx = Get-Secao $linhas '## 2. Contexto' '## 3. An'
$txtCtx = $secCtx -join ' '
$temPremissa = $txtCtx -match 'rela..o de consumo|entre empresas|n.o h. rela..o de consumo|destinat.rio final'
Test-Item -Nome "Secao 2 declara a premissa de regime (consumo x civil)" -Condicao $temPremissa `
    -Detalhe "a premissa que aciona o CDC precisa estar declarada e justificada"

# --------------------------------------------------------------- 3. evidencia

Write-Titulo "Regra de evidencia"

$qtdFundamentos = ([regex]::Matches(($analise -join "`n"), '\*\*Fundamento\*\*')).Count
$qtdNorma = ([regex]::Matches(($analise -join "`n"), '(?m)^\s*-\s*Norma:')).Count
$qtdVerificado = ([regex]::Matches(($analise -join "`n"), '(?m)^\s*-\s*Verificado em:')).Count
$qtdData = ([regex]::Matches(($analise -join "`n"), '(?m)^\s*-\s*Data da verifica..o:')).Count

Test-Item -Nome "Ha blocos de Fundamento" -Condicao ($qtdFundamentos -gt 0) `
    -Detalhe "encontrados: $qtdFundamentos"
Test-Item -Nome "Cada Norma tem 'Verificado em'" -Condicao ($qtdVerificado -ge $qtdNorma) `
    -Detalhe "Norma=$qtdNorma Verificado=$qtdVerificado"
Test-Item -Nome "Cada Norma tem 'Data da verificacao'" -Condicao ($qtdData -ge $qtdNorma) `
    -Detalhe "Norma=$qtdNorma Data=$qtdData"

$datasFuturas = @()
$hoje = Get-Date
foreach ($m in [regex]::Matches($texto, 'Data da verifica..o:\s*(\d{4})-(\d{2})-(\d{2})')) {
    $d = Get-Date -Year $m.Groups[1].Value -Month $m.Groups[2].Value -Day $m.Groups[3].Value
    if ($d -gt $hoje.AddDays(1)) { $datasFuturas += $m.Value }
}
Test-Item -Nome "Nenhuma data de verificacao no futuro" -Condicao ($datasFuturas.Count -eq 0) `
    -Detalhe ($datasFuturas -join '; ')

Test-Item -Nome "Menciona conferencia da biblioteca (STATUS-FONTES)" `
    -Condicao ($texto -match 'STATUS-FONTES') -Aviso `
    -Detalhe "a skill exige conferir atualidade antes de citar fontes/"

# -------------------------------------------------------------- 4. pendencias

Write-Titulo "Pendencias e sinalizacao"

$secPend = Get-Secao $linhas '## 7. Pend' '## 8. Fontes'
$linhasPend = @($secPend | Where-Object { $_ -match '^\|\s*\d+\s*\|' })
$qtdPendencias = $linhasPend.Count

$declaraNenhuma = ($secPend -join ' ') -match 'Nenhuma'

$temBlocoSinalizacao = $texto -match 'Pontos pendentes de parecer jur.dico'

if ($qtdPendencias -gt 0) {
    Write-Host "  INFO    Pendencias declaradas: $qtdPendencias" -ForegroundColor White

    Test-Item -Nome "Bloco de sinalizacao presente (ha pendencia)" -Condicao $temBlocoSinalizacao

    $secBloco = Get-Secao $linhas 'Pontos pendentes de parecer' 'ZZZ_NAO_EXISTE'
    $linhasBloco = @($secBloco | Where-Object { $_ -match '^\|\s*\d+\s*\|' })
    Test-Item -Nome "Contagem bate: secao 7 x bloco de sinalizacao" `
        -Condicao ($linhasBloco.Count -eq $qtdPendencias) `
        -Detalhe "secao7=$qtdPendencias bloco=$($linhasBloco.Count)"

    if ($texto -match 'Este documento tem \*\*(\d+)') {
        Test-Item -Nome "Numero declarado no bloco bate com a contagem" `
            -Condicao ([int]$Matches[1] -eq $qtdPendencias) `
            -Detalhe "declarado=$($Matches[1]) real=$qtdPendencias"
    }

    $mConsulta = [regex]::Match($texto, 'CONSULTA-ADVOGADO-[A-Za-z0-9\-]+\.md')
    Test-Item -Nome "Aponta arquivo de consulta ao advogado" -Condicao $mConsulta.Success

    if ($mConsulta.Success) {
        $caminhoConsulta = Join-Path (Split-Path -Parent (Resolve-Path -LiteralPath $Arquivo)) $mConsulta.Value
        if (Test-Path -LiteralPath $caminhoConsulta) {
            $txtConsulta = Get-Content -LiteralPath $caminhoConsulta -Raw -Encoding UTF8
            $qtdQuestoes = ([regex]::Matches($txtConsulta, '(?m)^###\s+Quest.o\s+\d+')).Count
            # o template repete os titulos na secao de resposta do advogado
            $qtdUnicas = (([regex]::Matches($txtConsulta, '(?m)^###\s+Quest.o\s+(\d+)')) |
                ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique).Count
            Test-Item -Nome "Consulta existe e tem uma questao por pendencia" `
                -Condicao ($qtdUnicas -eq $qtdPendencias) `
                -Detalhe "pendencias=$qtdPendencias questoes=$qtdUnicas (ocorrencias=$qtdQuestoes)"

            Test-Item -Nome "Consulta tem secao 'O que ja foi apurado'" `
                -Condicao ($txtConsulta -match 'O que j. foi apurado')
            Test-Item -Nome "Consulta reserva espaco para resposta do advogado" `
                -Condicao ($txtConsulta -match 'OAB')
        }
        else {
            Test-Item -Nome "Arquivo de consulta existe no disco" -Condicao $false `
                -Detalhe $mConsulta.Value
        }
    }
}
else {
    Write-Host "  INFO    Nenhuma pendencia declarada" -ForegroundColor White
    Test-Item -Nome "Secao 7 diz explicitamente que nao ha pendencia" -Condicao $declaraNenhuma `
        -Detalhe "esperado texto com 'Nenhuma'"
    Test-Item -Nome "Documento limpo NAO traz bloco de sinalizacao" -Condicao (-not $temBlocoSinalizacao) `
        -Detalhe "sem pendencia o documento sai sem ressalva"

    $ressalvas = @()
    foreach ($p in @('consulte um advogado', 'recomenda-se revis.o jur.dica',
            'gerado por intelig.ncia artificial', 'n.o substitui advogado',
            'este documento foi produzido por IA')) {
        if ($texto -match $p) { $ressalvas += $p }
    }
    Test-Item -Nome "Documento limpo nao tem ressalva generica" -Condicao ($ressalvas.Count -eq 0) `
        -Detalhe ($ressalvas -join '; ')
}

# ------------------------------------------------------------- 5. severidades

Write-Titulo "Consistencia de severidade"

$riscos = [regex]::Matches(($analise -join "`n"), '\*\*Risco:\*\*\s*([A-Za-z\-]+)')
$contagem = @{ 'Alto' = 0; 'M' = 0; 'Baixo' = 0 }
foreach ($r in $riscos) {
    $v = $r.Groups[1].Value
    if ($v -match '^Alto') { $contagem['Alto']++ }
    elseif ($v -match '^M') { $contagem['M']++ }
    elseif ($v -match '^Baixo') { $contagem['Baixo']++ }
}

$declAlto = $null; $declMedio = $null; $declBaixo = $null
if ($texto -match '\|\s*Risco alto\s*\|\s*(\d+)\s*\|') { $declAlto = [int]$Matches[1] }
if ($texto -match '\|\s*Risco m.dio\s*\|\s*(\d+)\s*\|') { $declMedio = [int]$Matches[1] }
if ($texto -match '\|\s*Risco baixo\s*\|\s*(\d+)\s*\|') { $declBaixo = [int]$Matches[1] }

if ($null -ne $declAlto) {
    Test-Item -Nome "Risco alto: tabela x analise" -Condicao ($declAlto -eq $contagem['Alto']) `
        -Detalhe "tabela=$declAlto analise=$($contagem['Alto'])"
}
if ($null -ne $declMedio) {
    Test-Item -Nome "Risco medio: tabela x analise" -Condicao ($declMedio -eq $contagem['M']) `
        -Detalhe "tabela=$declMedio analise=$($contagem['M'])"
}
if ($null -ne $declBaixo) {
    Test-Item -Nome "Risco baixo: tabela x analise" -Condicao ($declBaixo -eq $contagem['Baixo']) `
        -Detalhe "tabela=$declBaixo analise=$($contagem['Baixo'])"
}
if ($texto -match '\|\s*Pend.ncias de valida..o\s*\|\s*(\d+)\s*\|') {
    Test-Item -Nome "Pendencias: tabela x secao 7" -Condicao ([int]$Matches[1] -eq $qtdPendencias) `
        -Detalhe "tabela=$($Matches[1]) secao7=$qtdPendencias"
}

# --------------------------------------------------------------- 6. preencher

Write-Titulo "Campos a preencher e dados da empresa"

$secCampos = Get-Secao $linhas '## 5. Campos a preencher' '## 6. Requisitos'
$temListaCampos = @($secCampos | Where-Object { $_ -match '^\s*-\s*\[' }).Count

$qtdPreencherTotal = ([regex]::Matches($texto, '\[PREENCHER')).Count
$qtdPreencherSec9 = 0
if ($idxSecao9 -lt $linhas.Count) {
    $secao9 = $linhas[($idxSecao9 - 1)..($linhas.Count - 1)] -join "`n"
    $qtdPreencherSec9 = ([regex]::Matches($secao9, '\[PREENCHER')).Count
}

if ($qtdPreencherSec9 -gt 0) {
    Test-Item -Nome "Ha lista de campos a preencher (secao 5)" -Condicao ($temListaCampos -gt 0) `
        -Detalhe "[PREENCHER] no texto consolidado: $qtdPreencherSec9, itens na secao 5: $temListaCampos"
}
Write-Host "  INFO    [PREENCHER] no documento: $qtdPreencherTotal (secao 9: $qtdPreencherSec9)" -ForegroundColor White

# CNPJ inventado: numero concreto que NAO consta do documento de origem.
# Transcrever CNPJ que o proprio documento informa nao e invencao.
$cnpjs = @([regex]::Matches($texto, '\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}') |
    ForEach-Object { $_.Value } | Select-Object -Unique)

if ($cnpjs.Count -eq 0) {
    Test-Item -Nome "Nenhum CNPJ concreto no documento" -Condicao $true
}
elseif ($Original -and (Test-Path -LiteralPath $Original)) {
    $txtOrig2 = Get-Content -LiteralPath $Original -Raw -Encoding UTF8
    $inventados = @($cnpjs | Where-Object { $txtOrig2 -notmatch [regex]::Escape($_) })
    Test-Item -Nome "Todo CNPJ citado consta do documento de origem" `
        -Condicao ($inventados.Count -eq 0) `
        -Detalhe ("nao encontrado no original: " + ($inventados -join ', '))
}
else {
    Write-Host ("  AVISO   CNPJ presente, origem nao conferida -> " + ($cnpjs -join ', ')) -ForegroundColor Yellow
    Write-Host "          passe -Original para confirmar que nao foi inventado" -ForegroundColor Yellow
    $script:Avisos++
}

# --------------------------------------------------------------- 7. caracteres

Write-Titulo "Regras de caractere (manual de estilo)"

$proibidos = @{
    'travessao longo (em dash)'  = [char]0x2014
    'travessao medio (en dash)'  = [char]0x2013
    'aspa curva esquerda'        = [char]0x201C
    'aspa curva direita'         = [char]0x201D
    'apostrofo curvo'            = [char]0x2019
    'reticencias unicode'        = [char]0x2026
    'sinal de multiplicacao'     = [char]0x00D7
    'bullet solto'               = [char]0x2022
}
foreach ($k in $proibidos.Keys) {
    $c = $proibidos[$k]
    $n = ([regex]::Matches($texto, [regex]::Escape($c))).Count
    Test-Item -Nome "Sem $k" -Condicao ($n -eq 0) -Detalhe "ocorrencias: $n"
}

# ------------------------------------------------------------------ resultado

Write-Host ""
Write-Host ("-" * 70)
Write-Host "Passou: $script:Passou   Avisos: $script:Avisos   Falhas: $script:Falhas"

if ($script:Falhas -eq 0) {
    Write-Host "APROVADO" -ForegroundColor Green
    if ($script:Avisos -gt 0) {
        Write-Host "Ha avisos. Nao reprovam, mas confira antes de entregar." -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Lembrete: esta validacao e mecanica. Merito juridico, incidencia" -ForegroundColor DarkGray
    Write-Host "das normas e falso positivo continuam sendo leitura humana." -ForegroundColor DarkGray
    exit 0
}
else {
    Write-Host "REPROVADO - $script:Falhas item(ns)" -ForegroundColor Red
    exit 1
}
