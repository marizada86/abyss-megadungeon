const fs=require('fs'),path=require('path'),cp=require('child_process');const base='.atena/generated/path-revision-20261017';
const files=fs.readdirSync(base,{withFileTypes:true});
console.log('Root files:',files.filter(f=>f.isFile()).map(f=>({path:f.name,bytes:fs.statSync(base+'/'+f.name).size})));
const sessions=[];for(const f of files.filter(f=>f.isDirectory()&&/^s00[2345]-/.test(f.name))){const names=fs.readdirSync(base+'/'+f.name);const json=names.filter(n=>n.endsWith('.json')&&!/profile/.test(n)).map(n=>({path:f.name+'/'+n,bytes:fs.statSync(base+'/'+f.name+'/'+n).size}));if(json.length)sessions.push(...json);}
console.log('Session reports:',sessions);
const git=(args)=>cp.execFileSync('rtk',['proxy','git',...args],{encoding:'utf8',maxBuffer:8*1024*1024});
const head=git(['show','HEAD:.atena/state/plan.yaml']),current=fs.readFileSync('.atena/state/plan.yaml','utf8');
function span(s,key){const a=s.indexOf(key+':');if(a<0)throw Error('Missing '+key);const m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(s.slice(a));return[a,m?a+m.index:s.length]}
const[ha,hb]=span(head,'map_path_revision_proposal'),[ca,cb]=span(current,'map_path_revision_proposal');let staged=head.slice(0,ha)+current.slice(ca,cb)+head.slice(hb);
const[da,db]=span(staged,'dagruve_chapter2_proposal');let d=staged.slice(da,db);if(!d.includes('path_revision_suspension:'))d=d.trimEnd()+'\n  path_revision_suspension: CLOSED_PLAN_COMPLETE_RETURN_CURSOR_PRESERVED\n  path_revision_return_cursor: CP-DAG-005_S-DAG-005_4_OF_5_OWNER_FEEDBACK_PENDING\n\n';staged=staged.slice(0,da)+d+staged.slice(db);
fs.writeFileSync(base+'/publication-plan-index.yaml',staged);console.log('Prepared partial plan index; unrelated HQ additions remain local.');
