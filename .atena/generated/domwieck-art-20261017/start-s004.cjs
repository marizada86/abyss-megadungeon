const fs=require('fs'),crypto=require('crypto'),path=require('path');
const base='.atena/generated/domwieck-art-20261017/',read=p=>fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const kit=JSON.parse(read(base+'kit-r1/manifest.json'));
if(kit.owner_acceptance!=='APPROVED_OWNER_R1')throw Error('Kit not approved');
const targets=[...kit.entries.map(e=>'assets/tiles/domwieck_r1/'+e.id+'.png'),'data/domwieck_art.json','ui/ground.gd','ui/domwieck_art.gd','ui/stages/domwieck.tscn','tests/test_domwieck_art.gd'];
const guarded=['core/terrain_layout.gd','core/battle.gd','core/hero.gd','core/enemy.gd','core/chapter_flow.gd','data/level_design.json','data/stages.json','data/root_navigation.json','data/root_art.json','ui/stages/reino_abissal.tscn','ui/shaders/abyss_roots.gdshader','tests/test_root_art.gd'].filter(p=>fs.existsSync(p));
if(fs.existsSync(base+'s004-baseline.json'))throw Error('Existing baseline');
const baseline={targets:targets.map(p=>({path:p,existed:fs.existsSync(p),sha256:fs.existsSync(p)?hash(p):null})),guarded:guarded.map(p=>({path:p,sha256:hash(p)})),kit:kit.entries.map(e=>({path:e.path,sha256:e.sha256}))};
for(const e of baseline.kit)if(hash(e.path)!==e.sha256)throw Error('Kit hash mismatch');
for(const p of targets.filter(p=>fs.existsSync(p))){const dest=base+'s004-before/'+p;fs.mkdirSync(path.dirname(dest),{recursive:true});fs.copyFileSync(p,dest);}
fs.writeFileSync(base+'s004-baseline.json',JSON.stringify(baseline,null,2)+'\n');
const statePath='.atena/state/plan.yaml',s=read(statePath),end=s.indexOf('\nroot_art_plan:');let block=s.slice(0,end);
if(end<0||!block.includes('status: S_DART_003_COMPLETE_AWAITING_CP_DART_004'))throw Error('Checkpoint changed');
block=block.replace('status: S_DART_003_COMPLETE_AWAITING_CP_DART_004','status: S_DART_004_INTEGRATING').replace('current_step: S-DART-003','current_step: S-DART-004').replace('approval: APPROVED_S_DART_003_VISUAL_KIT_R1','approval: APPROVED_S_DART_004_INTEGRATION_ISOLATED_TESTS').replace('implementation_authorized: false','implementation_authorized: true').replace('next_step_approval: PENDING_S_DART_004','next_step_approval: APPROVED_S_DART_004').replace("next_activity: 'Autorizar S-DART-004: integrar conjunto aprovado e executar testes isolados'","next_activity: 'Integrar arte, validar recortes/escala/brilho e executar testes isolados'");
block+='  integration_authorization: "autorizado (2026-10-17), em resposta à integração, ajustes de recorte/escala/brilho, preservação das rotas/combate e testes isolados previstos"\n  integration_baseline: .atena/generated/domwieck-art-20261017/s004-baseline.json\n';
fs.writeFileSync(statePath,block+s.slice(end));
for(const e of kit.entries){const dest='assets/tiles/domwieck_r1/'+e.id+'.png';fs.mkdirSync(path.dirname(dest),{recursive:true});if(fs.existsSync(dest))throw Error('Unexpected existing image');fs.copyFileSync(e.path,dest);
 const importer=read('assets/tiles/reino_abissal_roots_r1/surface.png.import').replace(/^uid=.*\r?\n/m,'').replace(/surface\.png/g,e.id+'.png').replace(/reino_abissal_roots_r1/g,'domwieck_r1');
 const tag=crypto.createHash('md5').update('res://'+dest).digest('hex');fs.writeFileSync(dest+'.import',importer.replace(/0c784210b24e408b0c75d3cecb447da5/g,tag));
}
const cfg={version:1,stage_id:'domwieck',native_size:1254,import_max_size:1024,textures:Object.fromEntries(kit.entries.map(e=>[e.id,'res://assets/tiles/domwieck_r1/'+e.id+'.png'])),approved_hashes:Object.fromEntries(kit.entries.map(e=>[e.id,e.sha256])),building_anchors:[[7,20],[23,22],[37,38],[53,40],[7,39],[53,21]],burning_indices:[0,1,4],building_heights:[124,144,120,124,120,124],garden_center:[30,7],flower_radius:4,tree_radius:5.6,tree_count:28,tree_height:62,star_height:104,star_base_offset:[0,-3],ground_tint:'737c89',canopy_fade:0.32,excluded_garden_variants:[3],rects:{ground:[[0,0,0.5,0.5],[0.5,0,0.5,0.5],[0,0.5,0.5,0.5],[0.5,0.5,0.5,0.5]],architecture:[[0,0,0.52,0.52],[0.52,0,0.48,0.52],[0,0.52,0.52,0.48],[0.52,0.52,0.48,0.48]],vegetation:[[0,0,0.53,0.52],[0.53,0,0.47,0.52],[0,0.52,0.565,0.48],[0.565,0.52,0.435,0.48]],garden:[[0,0,0.5,0.5],[0.5,0,0.5,0.5],[0,0.5,0.5,0.5]],ailalore:[[0,0,1,1]],ambient:[[0,0,0.56,0.5],[0.56,0,0.44,0.5],[0,0.5,0.52,0.5],[0.52,0.5,0.48,0.5]]}};
fs.writeFileSync('data/domwieck_art.json',JSON.stringify(cfg,null,2)+'\n');
let validator=read('.atena/generated/root-art-20261017/validate-s004.ps1');
validator=validator.replace("@('test_root_art','test_root_navigation'","@('test_domwieck_art','test_root_art','test_root_navigation'").replaceAll('.atena/generated/root-art-20261017/capture-s004.gd','.atena/generated/domwieck-art-20261017/capture-s004.gd').replaceAll('.atena/generated/root-art-20261017/render-audit.gd','.atena/generated/domwieck-art-20261017/render-audit.gd');
fs.writeFileSync(base+'validate-s004.ps1',validator);
console.log('Baseline and authorization saved; six exact PNGs admitted, 1024 import limits; 11 source/test paths planned.');
