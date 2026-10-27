Add-Type -AssemblyName System.Drawing
$results = foreach ($file in Get-ChildItem $PSScriptRoot -Filter '*_v0?.png') {
    $im = [System.Drawing.Bitmap]::new($file.FullName)
    $eight = $file.Name.StartsWith('E03')
    $count = if ($eight) { 8 } else { 6 }
    $cell = if ($eight) { 384 } else { 256 }
    $frames = for ($i=0; $i -lt $count; $i++) {
        $col = if ($eight) { $i % 4 } else { $i }
        $row = if ($eight) { [int][math]::Floor($i/4) } else { 0 }
        $x0 = $col*$cell
        $y0 = if ($eight) { 128+$row*$cell } else { 384 }
        $minx=$cell; $miny=$cell; $maxx=-1; $maxy=-1
        for ($y=0; $y -lt $cell; $y++) {
            for ($x=0; $x -lt $cell; $x++) {
                $p=$im.GetPixel($x0+$x,$y0+$y)
                if ([math]::Max($p.R,[math]::Max($p.G,$p.B)) -gt 24) {
                    $minx=[math]::Min($minx,$x); $maxx=[math]::Max($maxx,$x)
                    $miny=[math]::Min($miny,$y); $maxy=[math]::Max($maxy,$y)
                }
            }
        }
        [ordered]@{frame=$i+1; bbox=@($minx,$miny,$maxx,$maxy); min_margin=[math]::Min([math]::Min($minx,$miny),[math]::Min($cell-1-$maxx,$cell-1-$maxy))}
    }
    $result=[ordered]@{file=$file.Name; size=@($im.Width,$im.Height); sha256=(Get-FileHash $file.FullName -Algorithm SHA256).Hash; frames=@($frames)}
    $im.Dispose()
    $result
}
[ordered]@{method='Nominal grid, RGB max > 24/255. Bounding boxes include neighbour contamination; not a separability or acceptance proof.'; results=@($results)} | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $PSScriptRoot 'pilot-source-audit.json') -Encoding utf8
$results | ForEach-Object { '{0}: minimum nominal margin {1}' -f $_.file, (($_.frames | ForEach-Object {$_.min_margin} | Measure-Object -Minimum).Minimum) }
