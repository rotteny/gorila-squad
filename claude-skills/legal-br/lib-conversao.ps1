# Legal BR - conversao das fontes oficiais para markdown.
#
# O markdown e derivado, nunca substituto. O arquivo original em fontes/
# continua sendo a evidencia. Se os dois divergirem, vale o original.
#
# Conversao mal feita e pior que HTML feio: um artigo que some do .md some em
# silencio, e o agente cita com confianca um texto incompleto. Por isso toda
# conversao passa por Test-Conversao antes de ser gravada.

# Extrai o texto corrido de um HTML, sem estrutura. E a base de comparacao da
# verificacao, entao precisa tratar as tags exatamente como ConvertTo-MarkdownFonte:
# se uma remove tag inline inserindo espaco e a outra nao, "Art.<span>5" vira
# "Art . 5" de um lado e "Art. 5" do outro, e a contagem diverge sem que nada
# tenha se perdido de fato. Comparacao so vale entre iguais.
function Get-TextoPlano {
    param([string]$Html)

    $t = $Html
    $t = [regex]::Replace($t, '(?is)<script.*?</script>', ' ')
    $t = [regex]::Replace($t, '(?is)<style.*?</style>', ' ')
    $t = [regex]::Replace($t, '(?is)<head.*?</head>', ' ')
    $t = [regex]::Replace($t, '(?s)<!--.*?-->', ' ')

    # Tags de bloco separam conteudo: viram espaco.
    $t = [regex]::Replace($t, '(?i)<br\s*/?>', ' ')
    $t = [regex]::Replace($t, '(?i)</(p|div|tr|li|h[1-6]|blockquote)>', ' ')
    $t = [regex]::Replace($t, '(?i)</t[dh]>', ' ')

    # Tags inline nao separam: o HTML do Word quebra palavras em <span>, e
    # inserir espaco aqui inventaria separacao que nao existe no texto legal.
    $t = [regex]::Replace($t, '<[^>]+>', '')

    $t = [System.Net.WebUtility]::HtmlDecode($t)
    $t = [regex]::Replace($t, '\s+', ' ')
    return $t.Trim()
}

# Le o arquivo respeitando o encoding real. Planalto serve ISO-8859-1,
# gov.br serve UTF-8. Sem isso o texto sai com acento quebrado.
function Read-Fonte {
    param([string]$Caminho)

    $bytes = [System.IO.File]::ReadAllBytes($Caminho)
    try {
        $utf8Estrito = New-Object System.Text.UTF8Encoding($false, $true)
        return $utf8Estrito.GetString($bytes)
    }
    catch {
        return [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($bytes)
    }
}

# HTML -> markdown, preservando a estrutura que importa juridicamente.
function ConvertTo-MarkdownFonte {
    param([string]$Html, [string]$Titulo, [string]$Url, [string]$ArquivoOrigem)

    $t = $Html

    # Fora o que nao e conteudo
    $t = [regex]::Replace($t, '(?is)<script.*?</script>', ' ')
    $t = [regex]::Replace($t, '(?is)<style.*?</style>', ' ')
    $t = [regex]::Replace($t, '(?is)<head.*?</head>', ' ')
    $t = [regex]::Replace($t, '(?s)<!--.*?-->', ' ')

    # Texto revogado vem riscado no Planalto. Perder isso muda o sentido juridico.
    $t = [regex]::Replace($t, '(?is)<(strike|s|del)>', '~~')
    $t = [regex]::Replace($t, '(?is)</(strike|s|del)>', '~~')

    # Blocos viram quebra de linha antes de a marcacao sumir
    $t = [regex]::Replace($t, '(?i)<br\s*/?>', "`n")
    $t = [regex]::Replace($t, '(?i)</(p|div|tr|li|h[1-6]|blockquote)>', "`n")
    $t = [regex]::Replace($t, '(?i)</t[dh]>', ' ')

    # Resto da marcacao
    $t = [regex]::Replace($t, '<[^>]+>', '')
    $t = [System.Net.WebUtility]::HtmlDecode($t)

    # Normaliza espacos sem colapsar as quebras de linha
    $t = $t -replace "`r`n", "`n"
    $t = $t -replace "`r", "`n"
    $t = [regex]::Replace($t, '[^\S\n]+', ' ')
    $t = [regex]::Replace($t, ' *\n *', "`n")
    $t = [regex]::Replace($t, '\n{3,}', "`n`n")
    $t = $t.Trim()

    # Estrutura: divisoes viram titulo, artigo vira ancora propria.
    # Regex compilada uma vez: sao milhares de linhas por arquivo.
    $reDivisao = [regex]::new('^(LIVRO|PARTE|T[ÍI]TULO|CAP[ÍI]TULO|SE[ÇC][ÃA]O|SUBSE[ÇC][ÃA]O)\s+[\dIVXLC]')
    $reArtigo  = [regex]::new('^(Art\.\s*\d+[.ºo°]*(?:-[A-Z])?)\s*(.*)$')

    $linhas = $t -split "`n"
    $saida = New-Object System.Collections.Generic.List[string]
    foreach ($linha in $linhas) {
        $l = $linha.Trim()
        if ($l -eq '') { $saida.Add(''); continue }

        if ($reDivisao.IsMatch($l)) {
            $saida.Add('')
            $saida.Add("## $l")
            $saida.Add('')
            continue
        }

        # "Art. 5o Para os fins desta Lei..." vira titulo + corpo separados,
        # senao o artigo inteiro viraria cabecalho.
        $m = $reArtigo.Match($l)
        if ($m.Success) {
            $saida.Add('')
            $saida.Add("### $($m.Groups[1].Value.Trim())")
            $saida.Add('')
            if ($m.Groups[2].Value.Trim() -ne '') { $saida.Add($m.Groups[2].Value.Trim()) }
            continue
        }

        $saida.Add($l)
    }

    $corpo = ($saida -join "`n")
    $corpo = [regex]::Replace($corpo, '\n{3,}', "`n`n")

    $cab = @(
        "# $Titulo"
        ''
        '> Convertido automaticamente para leitura. **A evidencia e o arquivo original.**'
        "> Ao transcrever texto legal literal, confirme em ``$ArquivoOrigem``."
        '>'
        "> Fonte oficial: $Url"
        ''
        '---'
        ''
    ) -join "`n"

    return $cab + $corpo.Trim() + "`n"
}

# Conta os marcadores que precisam sobreviver a conversao.
function Get-EstatisticasTexto {
    param([string]$Texto)

    return [PSCustomObject]@{
        Artigos      = ([regex]::Matches($Texto, 'Art\.\s*\d+')).Count
        Paragrafos   = ([regex]::Matches($Texto, '§')).Count
        Incisos      = ([regex]::Matches($Texto, '(?m)^\s*[IVXLC]+\s*[-–]')).Count
        Revogados    = ([regex]::Matches($Texto, '\(Revogad')).Count
        Redacoes     = ([regex]::Matches($Texto, '\(Reda[çc][ãa]o dada')).Count
        Incluidos    = ([regex]::Matches($Texto, '\(Inclu[íi]d')).Count
        Vides        = ([regex]::Matches($Texto, '\(Vide')).Count
        Palavras     = ([regex]::Matches($Texto, '\S+')).Count
    }
}

# Compara origem e markdown. Retorna a lista de problemas; vazia significa OK.
function Test-Conversao {
    param([string]$TextoOrigem, [string]$Markdown, [double]$ToleranciaPalavras = 0.02)

    # Tira a sintaxe de markdown antes de comparar, para nao contar o que o
    # proprio conversor acrescentou.
    $md = $Markdown
    $md = [regex]::Replace($md, '(?m)^> .*$', '')
    $md = [regex]::Replace($md, '(?m)^#{1,6} ', '')
    $md = [regex]::Replace($md, '(?m)^---$', '')
    $md = $md -replace '~~', ''
    $md = [regex]::Replace($md, '\s+', ' ').Trim()

    $a = Get-EstatisticasTexto -Texto $TextoOrigem
    $b = Get-EstatisticasTexto -Texto $md

    $problemas = @()

    foreach ($campo in @('Artigos', 'Paragrafos', 'Revogados', 'Redacoes', 'Incluidos', 'Vides')) {
        if ($a.$campo -ne $b.$campo) {
            $problemas += "$campo : origem $($a.$campo), markdown $($b.$campo)"
        }
    }

    # O volume de texto e checagem grossa, contra truncamento. As contagens
    # acima e que sao a garantia juridica, e essas tem que bater exatamente.
    #
    # A tolerancia tem piso absoluto porque em documento curto uma diferenca de
    # poucas palavras estoura qualquer percentual: numa pagina de 435 palavras,
    # 2% sao menos de 9 palavras. O piso nao esconde truncamento, que sempre
    # aparece em ordem de grandeza muito maior.
    if ($a.Palavras -gt 0) {
        $diferenca = [math]::Abs($b.Palavras - $a.Palavras)
        $limite = [math]::Max(20, [int]($a.Palavras * $ToleranciaPalavras))
        if ($diferenca -gt $limite) {
            $pct = [math]::Round(100 * $diferenca / [double]$a.Palavras, 1)
            $problemas += "volume de texto : origem $($a.Palavras) palavras, markdown $($b.Palavras) ($pct% de diferenca, limite $limite palavras)"
        }
    }

    return $problemas
}

# PDF -> markdown, via pdftotext. Sem a ferramenta, devolve $null e o chamador
# mantem o PDF: Claude e ChatGPT leem PDF nativamente de qualquer forma.
function ConvertTo-MarkdownPdf {
    param([string]$CaminhoPdf, [string]$Titulo, [string]$Url, [string]$ArquivoOrigem)

    $exe = Get-Command pdftotext -ErrorAction SilentlyContinue
    if (-not $exe) { return $null }

    $tmp = Join-Path $env:TEMP ((Split-Path $CaminhoPdf -Leaf) + '.txt')
    & $exe.Source -enc UTF-8 -nopgbrk $CaminhoPdf $tmp 2>$null | Out-Null
    if (-not (Test-Path $tmp)) { return $null }

    $texto = Get-Content $tmp -Raw -Encoding UTF8
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    if (-not $texto -or $texto.Trim().Length -lt 500) { return $null }

    $texto = $texto -replace "`r`n", "`n"
    $texto = [regex]::Replace($texto, '[^\S\n]+', ' ')
    $texto = [regex]::Replace($texto, '\n{3,}', "`n`n")

    $cab = @(
        "# $Titulo"
        ''
        '> Extraido do PDF oficial para leitura. **A evidencia e o PDF original.**'
        "> Ao transcrever trecho literal, confirme em ``$ArquivoOrigem``."
        '>'
        "> Fonte oficial: $Url"
        ''
        '---'
        ''
    ) -join "`n"

    return $cab + $texto.Trim() + "`n"
}
