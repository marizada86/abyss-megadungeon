const fs=require('fs'),path=require('path'),cp=require('child_process'),crypto=require('crypto');
const base='.atena/generated/path-revision-20261017',origin='D:/dev/nottgard/games/godot/nottgard-survivors',dest=path.resolve(base+'/origin-candidate');
if(fs.existsSync(dest))throw Error('Candidate already exists');
fs.mkdirSync(dest,{recursive:true});
// Candidate is a new local copy, never a link to or write in the real origin.
for(const name of ['project.godot','export_presets.cfg','icon.svg','core','data','ui','tests','tools','assets','audio','shaders'])if(fs.existsSync(origin+'/'+name))fs.cpSync(origin+'/'+name,dest+'/'+name,{recursive:true});
const changed=JSON.parse(fs.readFileSync(base+'/s002-baseline.json','utf8')).filter(e=>fs.existsSync(e.path)&&(!e.exists||crypto.createHash('sha256').update(fs.readFileSync(e.path)).digest('hex')!==e.sha256)).map(e=>e.path);
const dependencies=['core/enemy.gd','ui/stages/raiz_yggdrasil.tscn','data/prototype_stages.json','data/root_art.json','ui/shaders/abyss_roots.gdshader','assets/tiles/yggdrasil_r1','assets/tiles/reino_abissal_roots_r1','.atena/generated/yggdrasil-art-20261017/kit-r1/manifest.json','.atena/generated/root-art-20261017/kit-r1/manifest.json'];
for(const p of new Set([...changed,...dependencies])){fs.mkdirSync(path.dirname(dest+'/'+p),{recursive:true});fs.cpSync(p,dest+'/'+p,{recursive:true});}
fs.writeFileSync(base+'/portage-candidate-r1.json',JSON.stringify({status:'LOCAL_CANDIDATE_PENDING_APPLICATION_OWNER_APPROVAL',origin,destination:dest,origin_modified:false,changed,predecessor_pc_dependencies:dependencies,limit:'PC root prototype prerequisites absent in origin; explicit candidate dependencies, not a full origin release certification'},null,2));
fs.writeFileSync(base+'/portage-diff-r1.patch',cp.execFileSync('git',['diff','--no-ext-diff','--',...changed.filter(p=>p!=='core/root_path_generator.gd')],{encoding:'utf8'}));
console.log('Origin candidate prepared: '+dest+'; real origin untouched.');
