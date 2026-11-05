param([Parameter(Mandatory=$true)][string]$Id,[Parameter(Mandatory=$true)][string]$GeneratedPath)
$ErrorActionPreference='Stop'
$base=Split-Path -Parent $PSCommandPath
$root=(Resolve-Path (Join-Path $base '../../..')).Path
$sourceRoot=Join-Path $root 'assets_incoming/queue-20261104-r2/sources'
$queue=Get-Content (Join-Path $base 'queue.json') -Raw | ConvertFrom-Json
$q=@($queue | Where-Object {$_.id -eq $Id})
if($q.Count -ne 1){throw 'Unknown queue ID'}
$generatedFull=[IO.Path]::GetFullPath($GeneratedPath)
$allowed='C:\Users\Higor Rossini\.codex\generated_images\'
if(!$generatedFull.StartsWith($allowed,[StringComparison]::OrdinalIgnoreCase)){throw 'Unexpected generation source'}
$destination=Join-Path $sourceRoot ($Id+'_v01.png')
if(Test-Path -LiteralPath $destination){throw 'Preserve existing version; do not overwrite'}
Copy-Item -LiteralPath $generatedFull -Destination $destination
$sha=(Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
if($sha -ne (Get-FileHash -LiteralPath $generatedFull -Algorithm SHA256).Hash){throw 'Copy hash mismatch'}
Add-Type -AssemblyName System.Drawing
$bmp=[System.Drawing.Bitmap]::new($destination)
$item=[ordered]@{id=$Id;title=$q[0].title;type=$q[0].type;theme_provisional=$q[0].theme_provisional;source=('assets_incoming/queue-20261104-r2/sources/'+$Id+'_v01.png');original_generated_path=$generatedFull;sha256=$sha;byte_copy_verified=$true;width=$bmp.Width;height=$bmp.Height;prompt=('.atena/generated/asset-queue-20261104-r2/prompts/'+$Id+'.txt');prompt_sha256=(Get-FileHash -LiteralPath (Join-Path $base ('prompts/'+$Id+'.txt')) -Algorithm SHA256).Hash;technical_status='SOURCE_ONLY_CALIBRATION_PENDING';human_acceptance='PENDING'}
$bmp.Dispose()
Add-Content -LiteralPath (Join-Path $base 'results.jsonl') -Value ($item | ConvertTo-Json -Depth 6 -Compress) -Encoding utf8
$items=@(Get-Content (Join-Path $base 'results.jsonl') | ForEach-Object {$_ | ConvertFrom-Json})
$manifest=[ordered]@{date='2026-11-04';state='DRAFT';tool='built_in_imagegen';source_count=$items.Count;expected_count=19;prepared_count=0;runtime_modified=$false;items=$items}
$manifest | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $base 'manifest.json') -Encoding utf8
$planPath=Join-Path $root '.atena/state/plan.yaml'
$plan=Get-Content -LiteralPath $planPath -Raw
$pattern='(?ms)^asset_queue_remaining_20261104:\r?\n.*?(?=^[A-Za-z][A-Za-z0-9_]*:|\z)'
$hit=[regex]::Match($plan,$pattern)
if(!$hit.Success){throw 'Missing active plan'}
$section=[regex]::Replace($hit.Value,'(?m)^  generated_source_count:.*$',('  generated_source_count: '+$items.Count))
$section=[regex]::Replace($section,'(?m)^  checkpoint:.*$',('  checkpoint: S-R02/SOURCES_'+$items.Count+'_OF_19'))
$updated=$plan.Substring(0,$hit.Index)+$section+$plan.Substring($hit.Index+$hit.Length)
Set-Content -LiteralPath $planPath -Value $updated -Encoding utf8 -NoNewline
$cards=foreach($r in $items){'<article><h2>'+[Net.WebUtility]::HtmlEncode($r.title)+'</h2><a href="../../../'+$r.source+'"><img src="../../../'+$r.source+'" alt="'+$r.id+'"></a><p>Fonte '+$r.width+' × '+$r.height+' · DRAFT · aceite pendente</p><a href="prompts/'+$r.id+'.txt">Prompt exato</a></article>'}
$html='<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>VFX temáticos — segundo lote</title><style>body{background:#15171c;color:#e4e5e9;font:16px system-ui;margin:32px auto;padding:0 20px;max-width:1200px}a{color:#95c6ff}article{border:1px solid #464b58;padding:16px;margin:24px 0;border-radius:8px}img{max-width:100%;max-height:620px;display:block;margin:auto;background:#000}h2{font-size:20px}p{line-height:1.5}</style><h1>VFX temáticos — segundo lote</h1><p>04/11/2026 · '+$items.Count+'/19 fontes · imagegen · DRAFT. Clique para ampliar.</p><p>Calibração, preparação das folhas e aceite visual pendentes. Nenhum asset integrado. Temas interpretativos continuam propostas visuais.</p><p><a href="../asset-queue-20261104-r1/index.html">Primeiro lote — oito fontes aceitas pelo dono</a></p>'+($cards -join "`n")+'</html>'
Set-Content -LiteralPath (Join-Path $base 'index.html') -Value $html -Encoding utf8
[pscustomobject]@{id=$Id;saved=$item.source;width=$item.width;height=$item.height;progress=($items.Count.ToString()+'/19');copies_sha256='PASS'} | ConvertTo-Json -Compress
