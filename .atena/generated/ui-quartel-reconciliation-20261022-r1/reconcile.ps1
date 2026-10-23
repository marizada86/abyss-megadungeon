$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$production = Join-Path $root '.atena/generated/asset-production-20261021-r1'
$preparation = Join-Path $root '.atena/generated/asset-preparation-20261021-r1'
$accepted = Get-Content (Join-Path $production 'visual-acceptance.json') -Raw | ConvertFrom-Json
$audit = Get-Content (Join-Path $preparation 'audit.json') -Raw | ConvertFrom-Json
function Check-Hash([string]$Path, [string]$Expected) {
    if (!(Test-Path -LiteralPath $Path -PathType Leaf)) { return 'MISSING' }
    if ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ne $Expected) { return 'MISMATCH' }
    return 'MATCH'
}
$sources = @(foreach ($source in $accepted.accepted) {
    [ordered]@{ id = $source.id; file = $source.file; production = (Check-Hash (Join-Path $production $source.file) $source.sha256); incoming = (Check-Hash (Join-Path $root ('assets_incoming/' + $source.file)) $source.sha256) }
})
$derivatives = @(foreach ($item in $audit.artifacts) {
    $runtime = 'assets/' + ($item.file -replace '^prepared/', '')
    [ordered]@{
        id = $item.id; prepared_file = $item.file
        prepared = (Check-Hash (Join-Path $preparation $item.file) $item.sha256)
        runtime_file = $runtime
        runtime_hash_comparison = (Check-Hash (Join-Path $root $runtime) $item.sha256)
        note = 'Runtime comparison is provenance only; existence or equal hash does not prove consumer use. Missing/different N derivatives are not integration failures.'
    }
})
$consumers = @(
    'ui/menu.gd', 'ui/menu.tscn', 'ui/offer_card.gd', 'ui/hud.gd', 'ui/hud.tscn', 'ui/hud_art.gd',
    'ui/hero_panel.gd', 'ui/ability_slot.gd', 'data/interaction_anims.json', 'data/stage_events.json'
)
$snapshots = @(foreach ($relative in $consumers) {
    $path = Join-Path $root $relative
    [ordered]@{ file = $relative; sha256 = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash }
})
$anchors = @(
    @{id='U09'; file='ui/offer_card.gd'; pattern='func _draw_ornaments'; state='PENDING_CODE_HALO_EXISTS'},
    @{id='U11'; file='ui/offer_card.gd'; pattern='chips.add_child(_label(price'; state='PENDING_TEXT_PRICE_EXISTS'},
    @{id='U12'; file='ui/hero_panel.gd'; pattern='hud_painel_heroi é um molde fixo'; state='RETAINED_FIXED_LAYOUT'},
    @{id='U13/U14'; file='ui/hero_panel.gd'; pattern='HudArt.style_bar'; state='INTEGRATED'},
    @{id='U15'; file='ui/ability_slot.gd'; pattern='hud_habilidade_anel'; state='INTEGRATED'},
    @{id='U16'; file='ui/hero_panel.gd'; pattern='HudArt.chip_style'; state='INTEGRATED'},
    @{id='U17'; file='ui/hud.gd'; pattern='cronômetro: a faixa'; state='RETAINED_TOP_LAYOUT'},
    @{id='U18'; file='ui/hud.gd'; pattern='HudArt.style_square_button'; state='INTEGRATED_HELP_SPEED_ONLY'},
    @{id='U19'; file='ui/hud.gd'; pattern='lista de armas: a moldura'; state='RETAINED_VARIABLE_HEIGHT'},
    @{id='U20'; file='ui/hud.gd'; pattern='HudArt.modal_style'; state='INTEGRATED'},
    @{id='U21'; file='ui/offer_card.gd'; pattern='HudArt.modal_style(true)'; state='INTEGRATED'},
    @{id='Q02'; file='ui/menu.gd'; pattern='var hero_list: ItemList'; state='PENDING_ITEMLIST'},
    @{id='Q03'; file='ui/menu.gd'; pattern='var stage_list: ItemList'; state='PENDING_ITEMLIST'},
    @{id='Q05'; file='ui/menu.gd'; pattern='func _upgrade_pips'; state='INTEGRATED'},
    @{id='Q07/Q08'; file='ui/menu.gd'; pattern='cat_icon.modulate'; state='Q08_INTEGRATED_Q07_RETAINED'},
    @{id='Q09'; file='ui/menu.gd'; pattern='assets/icons/codex/'; state='INTEGRATED_THREE_EXISTING_CATEGORIES'},
    @{id='Q10'; file='ui/hud.gd'; pattern='var txt := "%s · %s'; state='PENDING_TEXT_RESULT_EXISTS'},
    @{id='N01'; file='data/interaction_anims.json'; pattern='npc_reaper_barqueiro'; state='INTEGRATED'}
)
$evidence = @(foreach ($anchor in $anchors) {
    $matches = @(Select-String -LiteralPath (Join-Path $root $anchor.file) -SimpleMatch -Pattern $anchor.pattern)
    if (!$matches.Count) { throw "Missing evidence anchor: $($anchor.id)" }
    [ordered]@{ id=$anchor.id; state=$anchor.state; file=$anchor.file; lines=@($matches.LineNumber); snippets=@($matches.Line.Trim()) }
})
$baselinePath = Join-Path $PSScriptRoot 'baseline.json'
$baseline = Get-Content -LiteralPath $baselinePath -Raw | ConvertFrom-Json
foreach ($row in $baseline.results) {
    $log = Get-Content -LiteralPath (Join-Path $baseline.session ($row.test + '.log')) -Raw
    $successPattern = if ($row.test -eq 'audit_projeto') { 'RESUMO;erros=0;' } else { [regex]::Escape($row.test) + ': 0 falha' }
    $assertionsPassed = $row.exit_code -eq 0 -and $log -match $successPattern -and $log -notmatch 'SCRIPT ERROR:|Parse Error:|FALHA '
    $row | Add-Member -Force -NotePropertyName assertions_passed -NotePropertyValue $assertionsPassed
    $row.passed = $assertionsPassed -and $log -notmatch 'ERROR:'
    $row | Add-Member -Force -NotePropertyName certificate_store_error -NotePropertyValue ($log -match 'Failed to read the root certificate store')
}
[IO.File]::WriteAllText($baselinePath, ($baseline | ConvertTo-Json -Depth 6))
$report = [ordered]@{
    revision='DRAFT/r1'; head=(& git -C $root rev-parse HEAD)
    authorization='seguir recomendações: reconcile current implementation and delimit remaining UI/HUD/Quartel scope'
    runtime_modified=$false; human_visual_acceptance='PENDING_FOR_GAME_SCREENS'
    source_acceptance='PRESERVED_125_NO_REACCEPTANCE'; sources=$sources; derivatives=$derivatives
    consumer_baseline=$snapshots; evidence=$evidence
    baseline='baseline.json'; runtime_scope_approval='PENDING_REVISED_REVIEWABLE_SCOPE'
    absent_global_instructions=@('C:/Users/gui-m/.codex/AGENTS.md','C:/Users/gui-m/.codex/RTK.md')
    historical_backlog='Origin D:/dev/nottgard/games/godot/nottgard-survivors/.atena not available here; no history copied'
}
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'audit.json'), ($report | ConvertTo-Json -Depth 8))
$sourceFailures = @($sources | Where-Object { $_.production -ne 'MATCH' -or $_.incoming -ne 'MATCH' }).Count
$preparedFailures = @($derivatives | Where-Object { $_.prepared -ne 'MATCH' }).Count
Write-Output "Sources=$($sources.Count); source_failures=$sourceFailures; derivatives=$($derivatives.Count); prepared_failures=$preparedFailures; evidence_groups=$($evidence.Count)"
if ($sources.Count -ne 125 -or $derivatives.Count -ne 158 -or $sourceFailures -or $preparedFailures) { exit 1 }
