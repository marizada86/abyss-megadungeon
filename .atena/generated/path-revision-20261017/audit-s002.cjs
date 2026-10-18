const fs=require('fs'),crypto=require('crypto'),path=require('path'),cp=require('child_process');const base='.atena/generated/path-revision-20261017';
const digest=p=>fs.existsSync(p)?crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'):null;
const baseline=JSON.parse(fs.readFileSync(base+'/s002-baseline.json','utf8'));
const changed=baseline.filter(e=>digest(e.path)!==e.sha256).map(e=>e.path);
if(changed.length>17)throw Error('Budget exceeded');
const old=JSON.parse(fs.readFileSync(base+'/s002-before/data/root_navigation.json','utf8'));
const now=JSON.parse(fs.readFileSync('data/root_navigation.json','utf8'));
if(JSON.stringify(old.reino_abissal)!==JSON.stringify(now.reino_abissal))throw Error('Abyss geometry changed prematurely');
for(const p of ['data/prototype_stages.json','ui/shaders/abyss_roots.gdshader','tests/test_root_art.gd'])if(digest(p)!==baseline.find(e=>e.path===p).sha256)throw Error('Abyss path changed '+p);
const original=JSON.parse(fs.readFileSync(base+'/portage-audit-r1.json','utf8'));
for(const e of original.files)if(digest(path.join(original.origin,e.path))!==e.origin_sha256)throw Error('Real origin changed: '+e.path);
const textureManifest=JSON.parse(fs.readFileSync('.atena/generated/yggdrasil-art-20261017/kit-r1/manifest.json','utf8'));
const config=JSON.parse(fs.readFileSync('data/yggdrasil_art.json','utf8'));
for(const e of textureManifest.entries)if(digest(config.textures[e.id].replace('res://',''))!==e.sha256)throw Error('Approved texture changed');
const build={step:'S-PATH-002',files:changed.map(p=>({path:p,sha256:digest(p)})),used_paths:changed.length,total_plan_budget:17,metadata:['core/root_path_generator.gd.uid'].filter(p=>fs.existsSync(p)),abyss_geometry_preserved:true,abyss_stage_shader_preserved:true,approved_yggdrasil_pngs_preserved:true,real_origin_unchanged:true};
fs.writeFileSync(base+'/s002-build.json',JSON.stringify(build,null,2));
for(const p of changed){const dest=base+'/portage-package/'+p;fs.mkdirSync(path.dirname(dest),{recursive:true});fs.copyFileSync(p,dest);}
const diff=cp.spawnSync('rtk',['proxy','git','diff','--no-ext-diff','--',...changed.filter(p=>p!=='core/root_path_generator.gd')],{encoding:'utf8'});if(diff.status!==0)throw Error('diff failed');fs.writeFileSync(base+'/portage-diff-r1.patch',diff.stdout);
console.log(JSON.stringify(build));
