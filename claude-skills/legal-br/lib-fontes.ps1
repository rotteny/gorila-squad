# Legal BR - funcoes comuns aos scripts de fontes oficiais.
#
# Carregado por ATUALIZAR-FONTES.ps1 e VERIFICAR-FONTES.ps1 via dot-source.
# Manter aqui evita que as duas copias saiam do lugar com o tempo.

# Valida o que foi baixado. Retorna $null se estiver OK, ou a descricao do problema.
# O gov.br devolve paginas de erro com HTTP 200, entao ausencia de excecao nao basta.
function Test-Download {
    param([string]$Caminho, [string]$Nome)

    if (-not $Nome) { $Nome = $Caminho }
    if (-not (Test-Path $Caminho)) { return 'arquivo nao foi criado' }

    $tamanho = (Get-Item $Caminho).Length
    if ($tamanho -lt 4096) { return "conteudo muito pequeno ($tamanho bytes)" }

    $bytes = New-Object byte[] 5
    $fs = [System.IO.File]::OpenRead($Caminho)
    try { $lidos = $fs.Read($bytes, 0, 5) } finally { $fs.Close() }
    $magic = [System.Text.Encoding]::ASCII.GetString($bytes, 0, $lidos)

    if ($Nome -match '\.pdf$') {
        if ($magic -ne '%PDF-') {
            return "esperado PDF, veio '$magic' (provavel pagina de erro salva com extensao .pdf)"
        }
        return $null
    }

    $texto = Get-Content -Path $Caminho -Raw -ErrorAction SilentlyContinue
    foreach ($marcador in @('Estamos em manuten', 'class="error_container"', 'class="error_message"')) {
        if ($texto -like "*$marcador*") { return "pagina de erro do portal (marcador: $marcador)" }
    }
    return $null
}

# Hash do CONTEUDO, nao dos bytes.
#
# As paginas do Planalto passam por um balanceador F5 que injeta a cada
# requisicao um <script id="f5_cspm"> com token aleatorio. O arquivo tem sempre
# o mesmo tamanho, mas o hash de bytes muda a cada download. Comparar bytes
# acusaria a Constituicao como alterada varias vezes ao dia.
#
# Para HTML, o hash e calculado sobre o texto visivel: scripts, estilos,
# comentarios e marcacao sao removidos antes. Assim o hash so muda quando o
# texto legal muda de fato.
#
# Para PDF, o hash e dos bytes mesmo. Os guias da ANPD sao estaveis.
function Get-HashConteudo {
    param([string]$Caminho, [string]$Nome)

    if (-not $Nome) { $Nome = $Caminho }

    if ($Nome -match '\.pdf$') {
        return (Get-FileHash $Caminho -Algorithm SHA256).Hash.ToUpper()
    }

    $bytes = [System.IO.File]::ReadAllBytes($Caminho)

    # Planalto serve ISO-8859-1, gov.br serve UTF-8. Tenta UTF-8 estrito primeiro.
    $texto = $null
    try {
        $utf8Estrito = New-Object System.Text.UTF8Encoding($false, $true)
        $texto = $utf8Estrito.GetString($bytes)
    }
    catch {
        $texto = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($bytes)
    }

    $texto = [regex]::Replace($texto, '(?is)<script.*?</script>', ' ')
    $texto = [regex]::Replace($texto, '(?is)<style.*?</style>', ' ')
    $texto = [regex]::Replace($texto, '(?s)<!--.*?-->', ' ')
    $texto = [regex]::Replace($texto, '<[^>]+>', ' ')
    $texto = $texto.Replace('&nbsp;', ' ')
    $texto = [regex]::Replace($texto, '\s+', ' ')
    $texto = $texto.Trim()

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $h = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($texto))
    }
    finally {
        $sha.Dispose()
    }
    return (($h | ForEach-Object { $_.ToString('X2') }) -join '')
}

# Le um arquivo no formato "HASH  caminho/relativo" e devolve uma hashtable.
function Read-Hashes {
    param([string]$Caminho)

    $mapa = @{}
    if (-not (Test-Path $Caminho)) { return $mapa }
    foreach ($linha in (Get-Content $Caminho -Encoding UTF8)) {
        if ($linha -match '^([0-9A-Fa-f]{64})\s+(.+)$') {
            $rel = ($matches[2].Trim()) -replace '\\', '/'
            $mapa[$rel] = $matches[1].ToUpper()
        }
    }
    return $mapa
}
