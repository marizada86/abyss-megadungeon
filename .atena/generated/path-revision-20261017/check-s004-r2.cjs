const fs=require('fs'),path=require('path'),crypto=require('crypto');
const base='.atena/generated/path-revision-20261017';const read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''));const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const report=read(base+'/s004-final-validation-r2.json'),build=read(report.build);let links=0;
for(const p of ['.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/contract-r1.md','.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/validation-adjustment-r2-draft.md'])for(const m of fs.readFileSync(p,'utf8').matchAll(/\]\((\.\.\/[^)]+)\)/g)){if(!fs.existsSync(path.resolve(path.dirname(p),m[1])))throw Error('Missing reference '+m[1]);links++;}
if(build.files.length!==18||build.files.some(f=>hash(f.path)!==f.sha256))throw Error('Build hash/budget');
const state=fs.readFileSync('.atena/state/plan.yaml','utf8'),a=state.indexOf('map_path_revision_proposal:'),m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(state.slice(a)),block=state.slice(a,m?a+m.index:state.length);
for(const expected of ['status: S_PATH_004_COMPLETE_AWAITING_S_PATH_005','completed_steps: 4','checkpoint: CP-PATH-005','next_step_approval: PENDING_S_PATH_005_ONLY','s004_native_suites: 12_OF_12_PASS'])if(!block.includes(expected))throw Error('State mismatch '+expected);
if(report.status!=='PASS'||report.human_playtest!=='PENDING_S_PATH_005_NOT_OPENED')throw Error('Acceptance mismatch');
const receipt={status:'PASS',relative_links_checked:links,build_hashes_verified:18,pc_suites:'12/12',candidate_suites:'7 renewed + native objective',performance:'PASS_REUSED_HASH_VERIFIED',checkpoint:'CP-PATH-005',human_playtest_opened:false};fs.writeFileSync(base+'/s004-delivery-check-r2.json',JSON.stringify(receipt,null,2)+'\n');console.log(receipt);
