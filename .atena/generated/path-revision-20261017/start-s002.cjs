const fs=require('fs'),path=require('path'),crypto=require('crypto');
const base='.atena/generated/path-revision-20261017';
const c=fs.readFileSync('.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/contract-r1.md','utf8');
const files=[...c.matchAll(/^\d+\. ([a-z][^ ]+\.(?:gd|json|gdshader)) —/gm)].map(m=>m[1]);
if(files.length!==17)throw Error('Budget');
const baseline=files.map(p=>{const exists=fs.existsSync(p);if(exists){const dest=base+'/s002-before/'+p;fs.mkdirSync(path.dirname(dest),{recursive:true});fs.copyFileSync(p,dest);}return {path:p,exists,sha256:exists?crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'):null}});
fs.writeFileSync(base+'/s002-baseline.json',JSON.stringify(baseline,null,2));
const state='.atena/state/plan.yaml';let s=fs.readFileSync(state,'utf8');
function edit(key,fields,append=''){const a=s.indexOf(key+':');if(a<0)throw Error(key);const m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(s.slice(a));const b=m?a+m.index:s.length;let block=s.slice(a,b);for(const [k,v]of Object.entries(fields)){const re=new RegExp(`(^|\\n)( +)${k}:.*`);if(!re.test(block))throw Error(k);block=block.replace(re,`$1$2${k}: ${v}`)}s=s.slice(0,a)+block.trimEnd()+'\n'+append+s.slice(b);}
const dag=s.slice(s.indexOf('dagruve_chapter2_proposal:'),s.indexOf('\nhq19_hq20_integration_plan:'));
fs.writeFileSync(base+'/dagruve-return-s002.txt',dag);
edit('dagruve_chapter2_proposal',{},'  path_revision_suspension: ACTIVE_FOR_AUTHORIZED_S_PATH_002\n  path_revision_return_cursor: CP-DAG-005_S-DAG-005_4_OF_5_OWNER_FEEDBACK_PENDING\n');
edit('map_path_revision_proposal',{status:'S_PATH_002_IMPLEMENTING_YGGDRASIL',current_step:'S-PATH-002',checkpoint:'CP-PATH-002',implementation_authorized:'true',contract_status:'APPROVED_OWNER_R1',next_activity:'Implementar Yggdrasil e executar checks isolados',next_step_approval:'AUTHORIZED_S_PATH_002_ONLY'},'  s002_authorization: Contrato r1 medidas posicoes teto17 aprovados; somente Yggdrasil e testes isolados\n  s002_baseline: '+base+'/s002-baseline.json\n');
fs.writeFileSync(state,s);
fs.writeFileSync('.atena/vault/canon/DEC-MAP-PATH-CONTRACT-20261017-r1.md','---\nid: DEC-MAP-PATH-CONTRACT-20261017\nrevision: r1\nstatus: CANON_OWNER_APPROVED_CONTRACT\n---\n\nTitular aprovou o contrato r1, incluindo medidas, posições e teto17, e autorizou apenas S-PATH-002 Yggdrasil/testes isolados.\n\nContrato: ../../specs/SPEC-NOTTGARD-PATH-REVISION-20261017/contract-r1.md. Dados: ../../generated/path-revision-20261017/geometry-contract-r1.json. Abismo S-PATH-003 e etapas seguintes aguardam checkpoints próprios. Origem não será alterada.\n');
fs.writeFileSync('.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/contract-r1.md',c.replace('status: DRAFT_AWAITING_CP_PATH_001','status: APPROVED_OWNER_R1_S_PATH_002_AUTHORIZED')+'\n## Aceite do contrato\n\nContrato r1 aprovado explicitamente, incluindo medidas, posições e teto17. Autorizada S-PATH-002 somente Yggdrasil e testes isolados. O texto DRAFT acima registra sua apresentação; decisão em DEC-MAP-PATH-CONTRACT-20261017-r1.\n');
console.log('Authorization and 17-path baseline recorded; Dagruve return cursor preserved.');
