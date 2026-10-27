Add-Type -AssemblyName System.Drawing
$ids = @('E01','E02','E04','E05','E06','E07','D02','T01','H01')
$results = foreach ($file in Get-ChildItem $PSScriptRoot -Filter '*_v0?.png' | Where-Object {$_.BaseName.Substring(0,3) -in $ids}) {
    $im=[System.Drawing.Bitmap]::new($file.FullName)
    if ($im.Width -ne 1536 -or $im.Height -ne 1024) { throw "Unexpected dimensions: $($file.Name)" }
    $eight=$file.Name.Substring(0,3) -in @('E04','E05')
    $cols=if($eight){4}else{6}; $cell=1536/$cols
    $bands=if($eight){@(@(0,479),@(480,1023))}else{@(@(0,1023))}
    $rowResults=foreach($band in $bands){
        $counts=New-Object int[] 1536
        for($x=0;$x -lt 1536;$x++){for($y=$band[0];$y -le $band[1];$y++){
            $p=$im.GetPixel($x,$y)
            if([math]::Max($p.R,[math]::Max($p.G,$p.B)) -gt 24){$counts[$x]++}
        }}
        $cuts=@(0); $borders=@()
        for($i=1;$i -lt $cols;$i++){
            $nominal=$i*$cell; $chosen=$nominal; $minimum=$counts[$chosen]
            for($d=1;$d -le 48;$d++){foreach($x in @(($nominal-$d),($nominal+$d))){if($counts[$x] -lt $minimum){$minimum=$counts[$x];$chosen=$x}}}
            $cuts+=$chosen
            $borders+=[ordered]@{nominal_x=$nominal; selected_x=$chosen; lit_pixels=$minimum; nominal_lit_pixels=$counts[$nominal]}
        }
        $cuts+=1536
        $frames=for($i=0;$i -lt $cols;$i++){
            $minx=1536;$maxx=-1;$miny=1024;$maxy=-1
            for($x=$cuts[$i];$x -lt $cuts[$i+1];$x++){if($counts[$x] -eq 0){continue};for($y=$band[0];$y -le $band[1];$y++){
                $p=$im.GetPixel($x,$y)
                if([math]::Max($p.R,[math]::Max($p.G,$p.B)) -gt 24){$minx=[math]::Min($minx,$x);$maxx=[math]::Max($maxx,$x);$miny=[math]::Min($miny,$y);$maxy=[math]::Max($maxy,$y)}
            }}
            [ordered]@{index=$i+1; bbox=@($minx,$miny,$maxx,$maxy); width=$maxx-$minx+1; height=$maxy-$miny+1; empty=($maxx -lt 0)}
        }
        [ordered]@{y_range=$band; cuts=$borders; frames=@($frames)}
    }
    $im.Dispose()
    [ordered]@{file=$file.Name; sha256=(Get-FileHash $file.FullName -Algorithm SHA256).Hash; size=@(1536,1024); rows=@($rowResults)}
}
[ordered]@{threshold='RGB max >24/255'; method='Vertical column scan over full row bands, search +/-48px around nominal cuts. Zero lit pixels gives a safe separator at this threshold, not visual or runtime approval.'; results=@($results)} | ConvertTo-Json -Depth 12 | Set-Content (Join-Path $PSScriptRoot 'remaining-source-audit-20261027.json') -Encoding utf8
$results | ForEach-Object { $bad=@($_.rows | ForEach-Object {$_.cuts} | Where-Object {$_.lit_pixels -gt 0}); '{0}: {1} nonempty separators' -f $_.file,$bad.Count }
