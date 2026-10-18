const fs=require('fs'),cp=require('child_process'),crypto=require('crypto');const base='.atena/generated/path-revision-20261017';
const git=(args,opts={})=>cp.execFileSync('rtk',['proxy','git',...args],{encoding:'utf8',maxBuffer:8*1024*1024,...opts});
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
if(git(['diff','--cached','--name-only']).trim())throw Error('Index already contains changes');
if(git(['rev-parse','HEAD']).trim()!==git(['rev-parse','origin/main']).trim())throw Error('Remote or local HEAD diverged; inspect');
const build=JSON.parse(fs.readFileSync(base+'/s004-build-r2.json'));for(const f of build.files)if(hash(f.path)!==f.sha256)throw Error('Build drift '+f.path);
const paths=[...build.files.map(f=>f.path),...build.metadata,'.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/proposal-r1.md','.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/contract-r1.md','.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/validation-adjustment-r2-draft.md'];
for(const dir of ['.atena/evidence','.atena/vault/canon'])for(const name of fs.readdirSync(dir))if(/^(EVID-NOTTGARD-PATH-|DEC-MAP-PATH-)/.test(name))paths.push(dir+'/'+name);
for(const f of fs.readdirSync(base,{withFileTypes:true})){
 if(f.isFile()&&/\.(json|cjs|ps1|gd|py|svg|patch)$/.test(f.name)&&!/publication-plan-index/.test(f.name))paths.push(base+'/'+f.name);
 if(f.isDirectory()&&/^s00[2345]-/.test(f.name))for(const name of fs.readdirSync(base+'/'+f.name))if(name.endsWith('.json')&&!/profile/.test(name))paths.push(base+'/'+f.name+'/'+name);
}
paths.push(base+'/drawings-r1.png');
for(const name of fs.readdirSync(base+'/r2-review'))if(/\.(txt|patch|json)$/.test(name))paths.push(base+'/r2-review/'+name);
const manifest=base+'/publication-manifest.json';paths.push(manifest);const unique=[...new Set(paths)].sort();
fs.writeFileSync(manifest,JSON.stringify({scope:'Approved Yggdrasil and first abyss path revision r2, tests, validation and human acceptance',owner_authorization:'atena, faça commit e push',target:'origin/main',game_test_files:18,metadata:build.metadata,paths:unique,partial_index_file:'.atena/state/plan.yaml',partial_index_scope:'Path revision block and its Dagruve suspension/return cursor only',excluded:'Other flows; project clones/baselines/portage duplicate package; synthetic profiles/userdirs; logs and local runtime captures. Existing reports retain local artifact locations for historical audit.',previous_head:git(['rev-parse','HEAD']).trim()},null,2)+'\n');
const list=base+'/publication-paths.nul';fs.writeFileSync(list,unique.join('\0')+'\0');git(['add','--pathspec-from-file='+list,'--pathspec-file-nul']);
const stagedPlan=fs.readFileSync(base+'/publication-plan-index.yaml');const blob=git(['hash-object','-w','--stdin'],{input:stagedPlan}).trim();git(['update-index','--cacheinfo','100644,'+blob+',.atena/state/plan.yaml']);
console.log(JSON.stringify({files:unique.length+1,bytes:unique.reduce((n,p)=>n+fs.statSync(p).size,0),scope:'18 game/test files + metadata and path documentation/receipts',partial_shared_state:true}));
