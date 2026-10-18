const fs=require('fs'),crypto=require('crypto'),path=require('path');
const base='.atena/generated/path-revision-20261017', target='tests/test_map_objectives.gd', candidate=base+'/r2-review/test_map_objectives.gd.candidate.txt';
const hash=p=>fs.existsSync(p)?crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'):null;
const write=(p,v)=>fs.writeFileSync(p,JSON.stringify(v,null,2)+'\n');
const build=JSON.parse(fs.readFileSync(base+'/s004-build.json'));
for(const f of build.files)if(hash(f.path)!==f.sha256)throw Error('Drift '+f.path);
if(hash(target)!==build.pending_18th.sha256_unchanged||hash(candidate)!==build.pending_18th.candidate_sha256)throw Error('Test drift');
const baseline=base+'/r2-review/test_map_objectives.before-r2.gd.txt';fs.copyFileSync(target,baseline);
const receipt={step:'S-PATH-004',revision:'r2',authorized_at_recorded:new Date().toISOString(),authorization:'Titular aprovou revisao r2, 18o arquivo, adaptacao e validacao para concluir S-PATH-004',budget:18,path:target,before:hash(target),approved_candidate:hash(candidate),baseline,previous_17_hashes_verified:true,fixtures:[],real_origin_modified:false};
write(base+'/s004-r2-authorization.json',receipt);
const canon='.atena/vault/canon/DEC-MAP-PATH-VALIDATION-ADJUSTMENT-20261017-r2.md';
fs.writeFileSync(canon,'---\nid: DEC-MAP-PATH-VALIDATION-ADJUSTMENT-20261017\nrevision: r2\nstatus: CANON_APPROVED_OWNER\n---\n\n# Ajuste da validação S-PATH-004\n\nO titular aprovou explicitamente a revisão r2 e autorizou tests/test_map_objectives.gd como 18º arquivo, a aplicação da candidata SHA256 '+receipt.approved_candidate+' e a validação para concluir S-PATH-004. O contrato r1 permanece vigente com teto de 18 arquivos. O ajuste afeta somente o teste de objetivos, com fixtures delimitados na cópia sintética da origem conforme a especificação r2. As exigências de aceitação e desempenho permanecem. S-PATH-005 requer autorização própria; nenhuma aprovação humana dos novos caminhos é inferida.\n\nEspecificação: .atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/validation-adjustment-r2-draft.md. Registro de execução: '+base+'/s004-r2-authorization.json.\n');
const spec='.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/validation-adjustment-r2-draft.md';
fs.writeFileSync(spec,fs.readFileSync(spec,'utf8').replace('status: DRAFT_AWAITING_CP_PATH_004_R2','status: APPROVED_OWNER_R2')+'\n## Aceite r2\n\nO titular aprovou a revisão r2 e autorizou explicitamente o 18º arquivo, a adaptação e a validação para concluir S-PATH-004. O texto de proposta acima é preservado como histórico anterior à implementação. Decisão canônica: '+canon+'.\n');
let state=fs.readFileSync('.atena/state/plan.yaml','utf8');const key='map_path_revision_proposal:',a=state.indexOf(key),m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(state.slice(a)),b=m?a+m.index:state.length;let block=state.slice(a,b);
const fields={revision:'r2',status:'S_PATH_004_R2_AUTHORIZED_VALIDATING',implementation_authorized:'true',next_step_approval:'APPROVED_OWNER_R2_S_PATH_004_ONLY',next_activity:'Aplicar teste 18 e validar objetivos em ambientes sinteticos',authorized_game_test_path_budget:'18',scope_adjustment_approval:'APPROVED_OWNER_R2_18TH_FILE'};
for(const[k,v]of Object.entries(fields))block=block.replace(new RegExp('^  '+k+':.*$','m'),'  '+k+': '+v);
block+='  s004_r2_authorization: '+base+'/s004-r2-authorization.json\n  scope_adjustment_canon: '+canon+'\n';
state=state.slice(0,a)+block+state.slice(b);state=state.replace(/path_revision_suspension: CLOSED_AT_S_PATH_004_R2_CHECKPOINT_RETURN_CURSOR_PRESERVED/g,'path_revision_suspension: ACTIVE_S_PATH_004_R2_RETURN_CURSOR_PRESERVED');fs.writeFileSync('.atena/state/plan.yaml',state);
fs.copyFileSync(candidate,target);
const origin=base+'/origin-candidate';fs.copyFileSync(target,origin+'/'+target);
for(const p of ['data/stages.json','data/scenery.json','data/level_design.json']){
 const pc=JSON.parse(fs.readFileSync(p)),dest=origin+'/'+p,doc=JSON.parse(fs.readFileSync(dest)),before=hash(dest),blocks=[];
 for(const id of ['reino_abissal','domwieck'])if(Object.hasOwn(pc,id)){doc[id]=pc[id];blocks.push(id);}
 if(blocks.length){fs.copyFileSync(dest,base+'/r2-review/'+path.basename(p)+'.origin-candidate-before-r2.json');write(dest,doc);}
 receipt.fixtures.push({path:p,admitted_blocks:blocks,before_sha256:before,after_sha256:hash(dest),pc_sha256:hash(p),scope:'SYNTHETIC_CANDIDATE_ONLY'});
}
receipt.applied_sha256=hash(target);receipt.origin_candidate_test_sha256=hash(origin+'/'+target);write(base+'/s004-r2-authorization.json',receipt);
console.log(JSON.stringify({applied:target,sha256:hash(target),fixtures:receipt.fixtures.map(f=>({path:f.path,blocks:f.admitted_blocks}))}));
