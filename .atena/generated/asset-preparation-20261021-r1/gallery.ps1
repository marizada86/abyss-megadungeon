$ErrorActionPreference='Stop'
$root=$PSScriptRoot
$r=Get-Content (Join-Path $root 'audit.json') -Raw -Encoding UTF8|ConvertFrom-Json
$cards=foreach($a in $r.artifacts){
 $f=$a.file;$group=if($f-match'^prepared/ui/'){'UI'}elseif($f-match'^prepared/icons/'){'Ícones'}else{'N'}
 "<article data-group='$group'><h3>$($a.id)</h3><a href='$f'><img loading='lazy' src='$f' alt='$($a.id)'></a><p>$($a.width)×$($a.height) · $($a.checks)</p><small>$f</small></article>"
}
$characters=foreach($a in $r.artifacts|Where-Object file -Match '^prepared/characters/'){
 $id=$a.id
 "<article class='animated' data-id='$id'><h3>$id · transição procedural</h3><div class='strip' style='background-image:url(prepared/animations/$id/idle.png);--end:-768px;--frames:4;--duration:0.8s'></div><select aria-label='Estado de $id' onchange='state(this)'><option value='idle'>Idle</option><option value='move'>Move</option><option value='attack'>Ataque</option><option value='death'>Morte</option></select></article>"
}
$html=@'
<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>Preparação DRAFT r1</title>
<style>
body{background:#191b23;color:#eee;font:16px system-ui;margin:0}header,section{padding:24px}a{color:#efcd8b}p{line-height:1.5}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:18px}article{padding:14px;border:1px solid #635135;border-radius:8px;background:#252934;overflow-wrap:anywhere}img{width:100%;height:220px;object-fit:contain}small{font-size:12px}.strip{margin:auto;width:192px;height:288px;background-size:auto 288px;background-repeat:no-repeat;animation:frames var(--duration) steps(var(--frames)) infinite}@keyframes frames{from{background-position:0 0}to{background-position:var(--end) 0}}.paused .strip{animation-play-state:paused}button,select{padding:10px;background:#453b2b;color:#fff;border:1px solid #c69b4c;border-radius:5px}nav{position:sticky;top:0;padding:12px;display:flex;gap:8px;background:#171820;z-index:2}h3{font-size:16px}
</style><header><h1>Preparação de assets · DRAFT r1</h1><p>125 fontes visualmente aceitas. 158 derivados preparados em pasta isolada: 62 peças de UI/Quartel, 36 poses, 12 sprites estáticos e 48 folhas de transição.</p><p>As fontes continuam preservadas. O jogo PC já tem integração parcial em dc4a917; estas saídas ainda não foram admitidas no runtime. As animações abaixo alternam poses com movimento procedural. Avalie continuidade, recorte e identidade; elas não são animação desenhada quadro a quadro.</p><p><a href="audit.json">Auditoria</a> · <a href="evidence.md">Evidência e pendências</a> · <a href="ui-review-board.png">Prancha UI</a> · <a href="n-review-board.png">Prancha personagens</a></p></header><nav><button onclick="filter('')">Todos</button><button onclick="filter('UI')">UI</button><button onclick="filter('Ícones')">Ícones</button><button onclick="filter('N')">Personagens N</button><button onclick="document.body.classList.toggle('paused')">Pausar animações</button></nav><section><h2>Prévia das folhas</h2><div class="grid">
'@
$html+=($characters -join [Environment]::NewLine)
$html+='</div></section><section><h2>Arquivos preparados</h2><div class="grid">'
$html+=($cards -join [Environment]::NewLine)
$html+=@'
</div></section><script>
function filter(g){document.querySelectorAll("[data-group]").forEach(a=>a.hidden=!!g&&a.dataset.group!==g)}
function state(s){let a=s.closest(".animated"),d=a.querySelector(".strip"),id=a.dataset.id,n={idle:4,move:6,attack:4,death:6}[s.value];d.style.backgroundImage="url(prepared/animations/"+id+"/"+s.value+".png)";d.style.setProperty("--end",(-n*192)+"px");d.style.setProperty("--frames",n);d.style.setProperty("--duration",(n/5)+"s");d.style.animation="none";void d.offsetWidth;d.style.animation=""}
</script></html>
'@
[IO.File]::WriteAllText((Join-Path $root 'index.html'),$html,(New-Object Text.UTF8Encoding($false)))

