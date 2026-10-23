$ErrorActionPreference='Stop'
$source='C:\Users\Higor Rossini\.codex\worktrees\3a88\nottgard-survivor'
$target='F:\dev\abyss-megadungeon'
$relTransfer='.atena/generated/asset-workflow-transfer-20261022-r1'
$localTransfer=Join-Path $source $relTransfer
$targetTransfer=Join-Path $target $relTransfer
$utf8=New-Object Text.UTF8Encoding($false)
function Write-Utf8($path,$text){[IO.File]::WriteAllText($path,$text,$utf8)}
$copies=@()
function Copy-Verified($from,$to,$rel){
 $hash=(Get-FileHash -LiteralPath $from -Algorithm SHA256).Hash
 if(Test-Path -LiteralPath $to){
  if((Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash-ne$hash){throw "Destination conflict preserved: $to"}
 }else{
  New-Item -ItemType Directory -Path (Split-Path $to) -Force|Out-Null
  Copy-Item -LiteralPath $from -Destination $to
 }
 if((Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash-ne$hash){throw "Copy mismatch: $to"}
 return @{file=$rel;sha256=$hash}
}
foreach($dir in @('.atena/generated/asset-production-20261021-r1','.atena/generated/asset-preparation-20261021-r1',$relTransfer)){
 $base=Join-Path $source $dir
 foreach($file in Get-ChildItem -LiteralPath $base -File -Recurse){
  if($file.Attributes-band[IO.FileAttributes]::ReparsePoint){throw "Unexpected reparse point: $($file.FullName)"}
  $rel=$dir+'/'+$file.FullName.Substring($base.Length+1).Replace('\','/')
  $copies+=Copy-Verified $file.FullName (Join-Path $target $rel) $rel
 }
}
$draft='.atena/vault/drafts/PROPOSTA-assets-20261021-r1.md'
$copies+=Copy-Verified (Join-Path $source $draft) (Join-Path $target $draft) $draft
Write-Output ('S-T02: '+$copies.Count+' files copied and hash verified.')
$prod=Join-Path $target '.atena/generated/asset-production-20261021-r1'
$manifest=Get-Content (Join-Path $prod 'manifest.json') -Raw -Encoding UTF8|ConvertFrom-Json
$sourceMap=@{}
foreach($a in $manifest.artifacts){$sourceMap[$a.generated_source]=(Join-Path $prod $a.file)}
$relocations=@()
foreach($a in $manifest.artifacts){
 $mapped=@();$changed=$false
 foreach($ref in $a.references){
  if($sourceMap.ContainsKey($ref)){$mapped+=$sourceMap[$ref];$changed=$true}
  elseif($ref.StartsWith($source,[StringComparison]::OrdinalIgnoreCase)){$mapped+=$target+$ref.Substring($source.Length);$changed=$true}
  else{$mapped+=$ref}
 }
 if($changed){
  $oldRefs=$a.references
  $a|Add-Member original_references $oldRefs -Force
  $a.references=$mapped
  $meta=Join-Path $prod ($a.id+'.json')
  $record=Get-Content $meta -Raw -Encoding UTF8|ConvertFrom-Json
  $record|Add-Member original_references $record.references -Force
  $record.references=$mapped
  Write-Utf8 $meta ($record|ConvertTo-Json -Depth 8)
  $relocations+=@{id=$a.id;original_references=$oldRefs;resolved_references=$mapped}
 }
 foreach($ref in $a.references){if(!(Test-Path -LiteralPath $ref)){throw "Unresolved reference: $ref"}}
}
$manifest|Add-Member authoritative_project $target -Force
Write-Utf8 (Join-Path $prod 'manifest.json') ($manifest|ConvertTo-Json -Depth 8)
$receipts=Join-Path $targetTransfer 'snapshots'
New-Item -ItemType Directory -Path $receipts -Force|Out-Null
foreach($rel in @('.atena/state/plan.yaml','.atena/add.yaml','AGENTS.md')){
 $from=Join-Path $target $rel
 $snap=Join-Path $receipts ($rel.Replace('/','_').Replace('.atena','atena'))
 if(Test-Path -LiteralPath $snap){throw "Snapshot already exists: $snap"}
 Copy-Item -LiteralPath $from -Destination $snap
}
$originState=Get-Content (Join-Path $source '.atena/state/plan.yaml') -Raw -Encoding UTF8
$sections=[regex]::Match($originState,'(?ms)^(asset_preparation_2026_10_21:.*?)(?=^hero_local_commit_2026_10_13:)').Groups[1].Value
if(!$sections){throw 'Source workflow sections not found'}
$targetPlan=Join-Path $target '.atena/state/plan.yaml'
$current=Get-Content -LiteralPath $targetPlan -Raw -Encoding UTF8
foreach($key in @('asset_preparation_2026_10_21:','asset_integration_proposal_2026_10_21:','asset_production_proposal_2026_10_21:','asset_workflow_transfer_20261022:')){
 if($current.Contains($key)){throw "Target state key already exists: $key"}
}
$receipt=@'
asset_workflow_transfer_20261022:
  revision: r1
  status: TRANSFERRED_AND_VERIFIED
  classification: PLAN_CHANGE_REQUEST_APPROVED_TRANSFER_ONLY
  mode: per-plan
  owner_reply: 'todo o processo será transferido para o projeto de abyss-megadungeon que é o nome do jogo agora'
  project_name: Abyss Megadungeon
  authoritative_project: F:/dev/abyss-megadungeon
  source_worktree: C:/Users/Higor Rossini/.codex/worktrees/3a88/nottgard-survivor
  source_commits: [d4419fe0, e337f3de]
  ordered_steps: [S-T01, S-T02, S-T03, S-T04]
  current_step_position: 3
  total_steps: 4
  completed_steps: 2
  remaining_steps_after_current: 1
  checkpoint: S-T03/VERIFY_DESTINATION
  handoff: .atena/generated/asset-workflow-transfer-20261022-r1/handoff.md
  source_acceptance: APPROVED_SELECTED_125_DRAFT
  generated_pngs: 129
  prepared_derivatives: 158
  integration_approval: PENDING_SCOPE_APPROVAL_PRESERVED
  canonical_asset_promotion: false
  runtime_modified_by_transfer: false
  commit_push: NOT_AUTHORIZED_FOR_TRANSFER
  next_objective: Resume asset integration proposal in this project after scope approval; do not request source acceptance again.
'@
$prefix=[regex]::Match($current,'\Aversion:\s*2\r?\n').Value
if(!$prefix){throw 'Unexpected target plan header'}
$newState=$prefix+$receipt+[Environment]::NewLine+$sections+$current.Substring($prefix.Length)
if((Get-Content $targetPlan -Raw -Encoding UTF8)-cne$current){throw 'Concurrent plan change detected'}
Write-Utf8 $targetPlan $newState
$add=Join-Path $target '.atena/add.yaml'
$addText=Get-Content $add -Raw -Encoding UTF8
if(!$addText.Contains('  name: Nottgard - Abyss Megadungeon')){throw 'Unexpected project name, preserved'}
Write-Utf8 $add ($addText.Replace('  name: Nottgard - Abyss Megadungeon','  name: Abyss Megadungeon'))
$agentPath=Join-Path $target 'AGENTS.md'
$agentText=Get-Content $agentPath -Raw -Encoding UTF8
$agentText=[regex]::Replace($agentText,'\A# Nottgard PC','# Abyss Megadungeon')
$agentText+=@'

## Continuidade da produção de assets

Em 2026-10-22, o dono transferiu este processo do projeto nottgard-survivor para abyss-megadungeon, nome de continuidade do jogo. Este projeto e sua .atena/ passam a ser a fonte operacional para essa frente. Consultar .atena/generated/asset-workflow-transfer-20261022-r1/handoff.md e as seções asset_* importadas em .atena/state/plan.yaml. A produção e o aceite das fontes estão concluídos; não repetir seu aceite nem gerar novamente. A proposta de integração ainda aguarda aprovação de escopo. Preservar os demais planos deste projeto. O repositório anterior é histórico, sem sincronização automática de volta.
'@
Write-Utf8 $agentPath $agentText
$canon=Join-Path $target '.atena/vault/canon/DEC-ASSET-WORKFLOW-TRANSFER-20261022-r1.md'
if(Test-Path -LiteralPath $canon){throw 'Decision already exists'}
Write-Utf8 $canon @'
# Continuidade do processo — Abyss Megadungeon — r1

Estado: CANON somente para a decisão de continuidade/nome explicitamente declarada pelo dono em 2026-10-22.

Fonte: “todo o processo será transferido para o projeto de abyss-megadungeon que é o nome do jogo agora”.

Destino operacional: F:/dev/abyss-megadungeon. Nome de continuidade do jogo: Abyss Megadungeon. A frente de produção, aceite, preparação e futura integração de assets continua neste projeto. A origem nottgard-survivor permanece histórica; não sincronizar alterações de volta automaticamente.

Preservar PRJ-NOTTGARD-PC, IDs técnicos, saves e conteúdo herdado. Não mudar retroativamente nomes em evidências históricas. A decisão não promove arte/lore DRAFT a CANON, não aprova o plano pendente de integração, não cria usos de personagens e não autoriza commit, push, build ou publicação.

Entrega desta frente: 129 fontes PNG, 125 candidatas selecionadas visualmente aceitas, quatro versões substituídas preservadas e 158 derivados preparados. Checkpoints e recibos foram transferidos com integridade verificada. Ver .atena/generated/asset-workflow-transfer-20261022-r1/handoff.md.
'@
$handoff=@'
# Retomada no projeto Abyss Megadungeon — 2026-10-22

Este projeto F:/dev/abyss-megadungeon é a fonte operacional da frente de assets, conforme decisão explícita do dono. Nome de continuidade: Abyss Megadungeon. A worktree de nottgard-survivor é origem histórica, sem sincronização automática nem nova implementação.

## O que já terminou

- Produção 8/8: 129 PNGs e prompts; 125 candidatas selecionadas, quatro versões substituídas.
- Aceite visual: explícito para as 125 fontes por ID/revisão/hash em ../asset-production-20261021-r1/visual-acceptance.json. Não pedir novamente.
- Preparação 5/5: 158 derivados, 62 peças de UI/Quartel, 36 poses, 12 sprites estáticos e 48 folhas de transição. Auditoria e galeria em ../asset-preparation-20261021-r1/.
- Entregas assets_incoming e a integração parcial PC dc4a917 já existiam e foram preservadas. Verificar o HEAD atual antes de novas alterações.

## Onde retomar

Estado: .atena/state/plan.yaml, seções asset_preparation_2026_10_21, asset_production_proposal_2026_10_21 e asset_integration_proposal_2026_10_21. Modo per-plan preservado. Proposta executável somente após aprovação de escopo: ../asset-preparation-20261021-r1/integration-proposal.md. Checkpoint S-I01/INTEGRATION_SCOPE_APPROVAL_PENDING, 0/6 etapas.

Proposta: integrar UI/HUD e Quartel restantes e adaptar N01 ao consumer existente npc_reaper_barqueiro. N02–N10 ficam como reserva de arte; novos eventos/chefes não foram aprovados. N11 reutiliza mímico. V10 sprite permanece retido pela compatibilidade das folhas. Não interpretar a transferência como aprovação dessa proposta.

Conteúdo visual permanece DRAFT, apesar do aceite. Nenhuma promoção de arte/lore a CANON. Somente a decisão explícita de continuidade/nome foi registrada em DEC-ASSET-WORKFLOW-TRANSFER-20261022-r1.

## Integridade e execução local

As duas pastas asset-production e asset-preparation são irmãs: caminhos relativos dos jobs e do audit.ps1 funcionam no destino. Usar o Godot já existente na raiz deste projeto; nenhum pacote novo é necessário. Projeto sintético de preparação não carrega autoload ou save real.

A cópia foi conferida por SHA-256. Referências internas a imagens geradas foram resolvidas para as fontes transferidas, quando aplicável; generated_source e original_references preservam a proveniência. Caminhos históricos em evidências não foram reescritos como se sempre pertencessem ao destino. Referências CANON do Vault continuam somente leitura.

Antes de executar: conferir AGENTS.md, add.yaml, estado atual e backlog; preservar outros trabalhos. Executar checks de assets e integração no projeto atual; aceite das fontes não prova funcionamento, animação ou diversão em jogo. Sem commit/push/merge/exportação autorizados por esta transferência.
'@
Write-Utf8 (Join-Path $targetTransfer 'handoff.md') $handoff
Write-Utf8 (Join-Path $localTransfer 'handoff.md') $handoff
$summary=[ordered]@{date='2026-10-22';state='FILES_TRANSFERRED_PENDING_FINAL_VALIDATION';source=$source;target=$target;copied_files=$copies.Count;source_pngs=129;accepted_sources=125;prepared_derivatives=158;relocated_reference_records=$relocations.Count;copies=$copies;relocations=$relocations;source_preserved=$true;runtime_modified=$false}
Write-Utf8 (Join-Path $targetTransfer 'transfer-audit.json') ($summary|ConvertTo-Json -Depth 8)
Write-Utf8 (Join-Path $localTransfer 'transfer-audit.json') ($summary|ConvertTo-Json -Depth 8)
Write-Output ('S-T03: state incorporated; '+$relocations.Count+' reference records relocated; all other plans preserved.')

