$ErrorActionPreference='Stop'
$root=$PSScriptRoot
$dest='F:\dev\abyss-megadungeon\assets_incoming\atena-prepared-20261021-r1'
$report=Get-Content (Join-Path $root 'audit.json') -Raw -Encoding UTF8|ConvertFrom-Json
if($report.holds-ne0-or$report.outputs-ne158){throw 'Preparation audit must pass'}
$paths=@($report.artifacts|ForEach-Object {$_.file})+@('index.html','audit.json','evidence.md','ui-review-board.png','n-review-board.png','integration-proposal.md')
$receipt=@()
foreach($rel in $paths){
 $from=Join-Path $root $rel
 $to=Join-Path $dest $rel
 $hash=(Get-FileHash -LiteralPath $from -Algorithm SHA256).Hash
 if(Test-Path -LiteralPath $to){
  if((Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash-ne$hash){throw "Destination conflict preserved: $to"}
 }else{
  New-Item -ItemType Directory -Path (Split-Path $to) -Force|Out-Null
  Copy-Item -LiteralPath $from -Destination $to
 }
 if((Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash-ne$hash){throw "Copy mismatch: $to"}
 $receipt+=@{file=$rel;sha256=$hash}
}
$result=[ordered]@{state='DRAFT';destination=$dest;png_derivatives=158;files=$receipt.Count;runtime_modified=$false;verified=$true;artifacts=$receipt}
[IO.File]::WriteAllText((Join-Path $root 'delivery.json'),($result|ConvertTo-Json -Depth 6),(New-Object Text.UTF8Encoding($false)))
$result|Select-Object destination,png_derivatives,files,verified

