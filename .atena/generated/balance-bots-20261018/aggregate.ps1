param([string]$Prefix = 'god-', [string]$Dir = 'F:\dev\abyss-megadungeon\.atena\generated\balance-bots-20261018\results')
# Agrega os .jsonl de um prefixo (god-, basegod-, mort-) e imprime tabelas por fase e por herói.
$rows = foreach ($f in Get-ChildItem $Dir -Filter "$Prefix*.jsonl") {
  foreach ($l in Get-Content $f.FullName -Encoding UTF8) { if ($l.Trim()) { $l | ConvertFrom-Json } }
}
if (-not $rows) { 'sem dados'; return }
$order = 'dagruve','docas','shedaklah','molor','durao','feng_tu','shendilavri','goranthis','pilares','reino_abissal','domwieck','raiz_yggdrasil'
"runs: $($rows.Count)"
'--- por fase (médias entre heróis)'
'{0,-14} {1,4} {2,6} {3,8} {4,9} {5,9} {6,7} {7,6} {8,6}' -f 'fase','n','ok%','clear_s','dano/min','dano_tot','kills','nivel','pico'
foreach ($s in $order) {
  $g = $rows | Where-Object { $_.stage -eq $s }
  if (-not $g) { continue }
  $ok = @($g | Where-Object { $_.outcome -in 'cleared','won' }).Count
  $ct = $g | Where-Object { $_.clear_time -gt 0 } | Measure-Object clear_time -Average
  $dpm = ($g | ForEach-Object { $_.damage_taken / [math]::Max(1, $_.run_time / 60) } | Measure-Object -Average).Average
  '{0,-14} {1,4} {2,5}% {3,8:N0} {4,9:N0} {5,9:N0} {6,7:N0} {7,6:N1} {8,6:N0}' -f $s, $g.Count, [int](100 * $ok / $g.Count), $ct.Average, $dpm, ($g | Measure-Object damage_taken -Average).Average, ($g | Measure-Object kills -Average).Average, ($g | Measure-Object level -Average).Average, ($g | Measure-Object peak_enemies -Average).Average
}
'--- por herói (dano/min médio entre fases, kills médios)'
foreach ($h in ($rows | Group-Object hero)) {
  $dpm = ($h.Group | ForEach-Object { $_.damage_taken / [math]::Max(1, $_.run_time / 60) } | Measure-Object -Average).Average
  $bad = @($h.Group | Where-Object { $_.outcome -notin 'cleared','won' }) | ForEach-Object { $_.stage }
  '{0,-10} n={1,2} dano/min={2,7:N0} kills={3,5:N0} nao_concluiu=[{4}]' -f $h.Name, $h.Count, $dpm, ($h.Group | Measure-Object kills -Average).Average, ($bad -join ',')
}
