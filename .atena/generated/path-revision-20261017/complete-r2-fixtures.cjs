const fs=require('fs'),crypto=require('crypto');const base='.atena/generated/path-revision-20261017';
const hash=p=>fs.existsSync(p)?crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'):null;
const p=base+'/s004-r2-authorization.json',r=JSON.parse(fs.readFileSync(p));r.failed_candidate_attempt={session:base+'/s004-20261018-022124-026',reason:'Missing predecessor PC scenes reino_abissal/domwieck; engine errors rejected despite test runner reporting zero assertions',accepted:false};
r.additional_predecessor_pc_dependencies=[];
for(const file of ['ui/stages/reino_abissal.tscn','ui/stages/domwieck.tscn','ui/domwieck_art.gd']){const dest=base+'/origin-candidate/'+file;r.additional_predecessor_pc_dependencies.push({path:file,before_sha256:hash(dest),pc_sha256:hash(file),purpose:'Existing PC scene dependency for native objective geometry test, synthetic candidate only'});fs.copyFileSync(file,dest);}
fs.writeFileSync(p,JSON.stringify(r,null,2)+'\n');console.log(r.additional_predecessor_pc_dependencies);
