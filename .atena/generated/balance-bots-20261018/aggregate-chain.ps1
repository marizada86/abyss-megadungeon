param([string]$Prefix = 'chainA-', [string]$Compare = '', [string]$Dir = 'F:\dev\abyss-megadungeon\.atena\generated\balance-bots-20261018\results')
# Achata os segmentos por fase de runs encadeadas. Com -Compare, mostra a variação percentual contra o outro prefixo (mesmos heróis).
function Load($pfx) {
  foreach ($f in Get-ChildItem $Dir -Filter "$pfx*.jsonl") {
    foreach ($l in Get-Content $f.FullName -Encoding UTF8) {
      if (-not $l.Trim()) { continue }
      $r = $l | ConvertFrom-Json
      foreach ($s in $r.segments) {
        [pscustomobject]@{ hero = $r.hero; seed = $r.seed; stage = $s.stage; result = $s.result; t = $s.t; damage = $s.damage; kills = $s.kills; level = $s.level; min_hp = $s.min_hp; max_hp = $s.max_hp }
      }
    }
  }
}
$cur = @(Load $Prefix)
if (-not $cur) { 'sem dados'; return }
$base = @(); if ($Compare) { $base = @(Load $Compare) }
$stages = $cur | Select-Object -ExpandProperty stage -Unique
'{0,-14} {1,4} {2,5} {3,7} {4,9} {5,9} {6,6} {7,6} {8,7}' -f 'fase','n','ok%','t_s','dano','dano/min','kills','nivel','min_hp'
foreach ($s in $stages) {
  $g = @($cur | Where-Object { $_.stage -eq $s })
  $ok = @($g | Where-Object { $_.result -in 'cleared','won' }).Count
  $dpm = ($g | ForEach-Object { $_.damage / [math]::Max(1, $_.t / 60) } | Measure-Object -Average).Average
  '{0,-14} {1,4} {2,4}% {3,7:N0} {4,9:N0} {5,9:N0} {6,6:N0} {7,6:N1} {8,7:N2}' -f $s, $g.Count, [int](100 * $ok / $g.Count), ($g | Measure-Object t -Average).Average, ($g | Measure-Object damage -Average).Average, $dpm, ($g | Measure-Object kills -Average).Average, ($g | Measure-Object level -Average).Average, ($g | Measure-Object min_hp -Average).Average
  if ($base) {
    $heroes = $g | Select-Object -ExpandProperty hero -Unique
    $b = @($base | Where-Object { $_.stage -eq $s -and $_.hero -in $heroes })
    $c = @($g | Where-Object { $_.hero -in ($b | Select-Object -ExpandProperty hero -Unique) })
    if ($b.Count -gt 0 -and $c.Count -gt 0) {
      $dmgC = ($c | Measure-Object damage -Average).Average; $dmgB = ($b | Measure-Object damage -Average).Average
      $tC = ($c | Measure-Object t -Average).Average; $tB = ($b | Measure-Object t -Average).Average
      $kC = ($c | Measure-Object kills -Average).Average; $kB = ($b | Measure-Object kills -Average).Average
      $okC = @($c | Where-Object { $_.result -in 'cleared','won' }).Count / $c.Count; $okB = @($b | Where-Object { $_.result -in 'cleared','won' }).Count / $b.Count
      '   vs base (n={0}/{1}): dano {2:+0;-0}% · kills {3:+0;-0}% · tempo {4:+0;-0}% · clear {5:P0} -> {6:P0}' -f $c.Count, $b.Count, (100 * ($dmgC - $dmgB) / [math]::Max(1, $dmgB)), (100 * ($kC - $kB) / [math]::Max(1, $kB)), (100 * ($tC - $tB) / [math]::Max(1, $tB)), $okB, $okC
    }
  }
}
'--- por herói (dano médio por fase / nível final)'
foreach ($h in ($cur | Group-Object hero)) {
  $last = $h.Group | Sort-Object seed | Select-Object -Last 1
  '{0,-10} dano/fase={1,6:N0} kills/fase={2,5:N0} nivel_max={3,3} nao_concluiu=[{4}]' -f $h.Name, ($h.Group | Measure-Object damage -Average).Average, ($h.Group | Measure-Object kills -Average).Average, ($h.Group | Measure-Object level -Maximum).Maximum, ((@($h.Group | Where-Object { $_.result -notin 'cleared','won' }) | ForEach-Object { "$($_.stage)/s$($_.seed)" }) -join ',')
}
