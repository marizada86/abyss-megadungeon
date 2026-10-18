const fs=require('fs');
const s=fs.readFileSync('.atena/state/plan.yaml','utf8');
for(const key of ['map_path_revision_proposal']) {const a=s.indexOf(key+':');const m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(s.slice(a));console.log(s.slice(a,m?a+m.index:s.length));}
for(const p of ['.atena/generated/path-revision-20261017/s004-portage.json','.atena/generated/path-revision-20261017/portage-audit-r1.json','.atena/generated/path-revision-20261017/s004-validation-progress.json'])console.log(p,fs.readFileSync(p,'utf8'));
for(const p of ['data/stages.json','data/scenery.json','data/level_design.json']) {const d=JSON.parse(fs.readFileSync(p));console.log(p,Array.isArray(d),Object.keys(d).slice(0,25));}
