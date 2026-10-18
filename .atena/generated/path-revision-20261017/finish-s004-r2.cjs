const fs=require('fs'),crypto=require('crypto'),path=require('path');
const base='.atena/generated/path-revision-20261017';
const read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''));
const hash=p=>fs.existsSync(p)?crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex'):null;
const write=(p,v)=>fs.writeFileSync(p,JSON.stringify(v,null,2)+'\n');
const check=(v,m)=>{if(!v)throw Error(m)};
const prior=read(base+'/s004-build.json'),auth=read(base+'/s004-r2-authorization.json'),progress=read(base+'/s004-validation-progress.json'),perf=read(base+'/s004-performance-comparison.json');
const pc=base+'/s004-20261018-022041-748',origin=process.argv[2],originSeven=process.argv[3];
check(origin&&originSeven,'Supply successful objective and seven-suite candidate sessions');
for(const session of [pc,origin]){const r=read(session+'/results.json');check(r.results.length===1&&r.results[0].test==='test_map_objectives'&&r.results[0].passed,'Native objective failed '+session);check(r.user_dir.replace(/\\/g,'/').includes('/'+session+'/a/'),'Non-synthetic userdir');}
for(const f of prior.files)check(hash(f.path)===f.sha256,'Build drift '+f.path);
check(hash(auth.path)===auth.approved_candidate,'Test drift');
check(perf.status==='PASS'&&perf.checks.every(c=>c.passed&&c.ratio<=c.limit),'Performance failed');
for(const f of perf.raw_sha256)check(hash(base+'/'+f.session+'/performance.json')===f.sha256,'Performance raw drift '+f.session);
const previous=read(progress.suites.pc_session+'/results.json');check(previous.results.length===11&&previous.results.every(r=>r.passed),'Previous suites invalid');
const sourceSeven=read(originSeven+'/results.json');check(sourceSeven.results.length===7&&sourceSeven.results.every(r=>r.passed),'Candidate seven suites failed');
for(const f of auth.additional_predecessor_pc_dependencies||[])check(hash(base+'/origin-candidate/'+f.path)===f.pc_sha256,'Predecessor dependency drift '+f.path);
const original=read(base+'/portage-audit-r1.json');
const originAudit=original.files.map(f=>({path:f.path,baseline:f.origin_sha256,current:hash(original.origin+'/'+f.path)}));
check(originAudit.every(f=>f.baseline===f.current),'Real origin changed since baseline; inspect before concluding');
const files=[...prior.files,{path:auth.path,sha256:hash(auth.path)}];check(files.length===18&&new Set(files.map(f=>f.path)).size===18,'Budget');
for(const f of files){check(hash(base+'/origin-candidate/'+f.path)===f.sha256,'Candidate drift '+f.path);const dst=base+'/portage-package/'+f.path;fs.mkdirSync(path.dirname(dst),{recursive:true});fs.copyFileSync(f.path,dst);}
const build={step:'S-PATH-004',revision:'r2',status:'TECHNICAL_VALIDATION_PASS_HUMAN_PLAYTEST_PENDING',files,used_paths:18,budget:18,metadata:prior.metadata,predecessor:base+'/s004-build.json',only_r2_game_test_change:auth.path};write(base+'/s004-build-r2.json',build);
const portage={...read(base+'/s004-portage.json'),revision:'r2',status:'LOCAL_CANDIDATE_TESTED_PENDING_APPLICATION_OWNER_APPROVAL',files,fixtures:auth.fixtures,additional_predecessor_pc_dependencies:auth.additional_predecessor_pc_dependencies,objective_test_pc_session:pc,objective_test_candidate_session:origin,seven_suite_candidate_session:originSeven,real_origin_audit:originAudit,real_origin_test_sha256:hash(original.origin+'/'+auth.path),real_origin_modified:false,release_certification:false};write(base+'/s004-portage-r2.json',portage);
const evidence='.atena/evidence/EVID-NOTTGARD-PATH-JOINT-VALIDATION-20261017-r2.md';
const report={step:'S-PATH-004',revision:'r2',status:'PASS',completed_steps:4,total_steps:5,build:base+'/s004-build-r2.json',authorization:base+'/s004-r2-authorization.json',evidence,suites:{passed:12,total:12,reused_11:progress.suites.pc_session,new_native_objective:pc,names:[...progress.suites.passed_names,'test_map_objectives']},origin_candidate:{reused_seven:progress.origin_candidate.session,new_native_objective:origin,fixtures:auth.fixtures,real_origin_modified:false,release_certification:false},performance:{comparison:progress.performance,status:'PASS',reused:true,reason:'All 17 code/resource/test hashes unchanged; revision r2 changes objective test only',raw_hashes_verified:true},support_parity:progress.support_parity,render_sessions:progress.render_sessions,reused:progress.reused,budget:{used:18,authorized:18},history:{partial:base+'/s004-validation-progress.json',previous_failure:progress.suites.failure_log,preview:progress.draft_test_preview},portage:base+'/s004-portage-r2.json',human_playtest:'PENDING_S_PATH_005_NOT_OPENED',next_checkpoint:'CP-PATH-005'};write(base+'/s004-final-validation-r2.json',report);
report.origin_candidate.previous_seven=report.origin_candidate.reused_seven;
delete report.origin_candidate.reused_seven;
report.origin_candidate.renewed_seven=originSeven;
report.origin_candidate.renewal_reason='Integration fixtures and predecessor PC scenes admitted after prior seven-suite run';
report.origin_candidate.additional_predecessor_pc_dependencies=auth.additional_predecessor_pc_dependencies;
report.history.failed_candidate_attempt=auth.failed_candidate_attempt;
write(base+'/s004-final-validation-r2.json',report);
fs.writeFileSync(evidence,`# S-PATH-004 — validação conjunta concluída, revisão r2

Resultado: PASS técnico, etapa 4/5 concluída; quatro etapas concluídas e uma restante. Relatório: ${base}/s004-final-validation-r2.json. Build: ${base}/s004-build-r2.json, 18/18 arquivos de jogo/testes e UID declarado separadamente. Aprovação r2 registrada antes da aplicação em ${base}/s004-r2-authorization.json e na decisão DEC-MAP-PATH-VALIDATION-ADJUSTMENT-20261017-r2.

## Adaptação e testes

Aplicada exatamente a candidata aprovada em tests/test_map_objectives.gd, SHA256 ${auth.approved_candidate}. Chegada, destinos, percurso bidirecional das arestas e spawns usam a geometria vigente, preservando verificações de Domwieck, duração, presença, pausa, morte, abandono, idempotência, limpeza, caps e chefes legados. Baseline preservado no recibo de autorização. A falha anterior e a prévia continuam históricas; não foram reclassificadas como aprovação nativa.

Suíte nativa test_map_objectives: zero falhas no PC (${pc}) e na cópia sintética candidata (${origin}). Importação e execução sem erros, com APPDATA/LOCALAPPDATA/perfil novos e probe sem autoload confirmando user_dir isolado antes do jogo. Nenhum save real carregado.

Consolidado PC: 12/12 suítes aprovadas. As outras 11 são reutilizadas de ${progress.suites.pc_session}; todos os 17 hashes anteriores foram conferidos e permanecem iguais. Na origem candidata os sete checks foram renovados em ${originSeven} por causa dos fixtures de integração adicionados; também passou a suíte nativa de objetivos. Para esta integração, somente os blocos reino_abissal/domwieck de data/stages.json e data/level_design.json foram admitidos na cópia; data/scenery.json não possui esses blocos no PC e ficou intacto. A primeira tentativa candidata foi rejeitada por falta das cenas antigas do PC, mesmo com zero assertions reportadas. Foram admitidas as cenas existentes ui/stages/reino_abissal.tscn e ui/stages/domwieck.tscn e sua dependência ui/domwieck_art.gd, com hashes no recibo. São pré-requisitos de integração somente na cópia sintética, sem novos arquivos de jogo no PC. O erro e os demais pré-requisitos estão preservados no recibo de portagem/autorização. Isso não certifica release da origem.

## Desempenho e correção

Medições e método permanecem no relatório r1 e em ${progress.performance}: CPU mediana/p95 ≤1,15×baseline; render CPU e GPU p95 ≤1,20×baseline, todos aprovados. Os hashes dos dados brutos foram conferidos. Não se repetiu benchmark por alteração exclusiva de teste. Godot 4.7.2 debug, OpenGL3/Compatibility, GTX1650, i5-9400F; 30 frames de aquecimento +600 medidos por mapa; seed7504/Ygg40 e seed7202/Abismo50. Limites de amostragem e fixtures sintéticos permanecem os descritos no relatório r1.

Reutilizadas paridade de suporte (288.000 consultas, zero diferenças), 128 sementes/128 variantes/zero fallback, simulações integrais 240/360s e capturas/máscaras dos dois mapas em 1280×720 e 1920×1080. Nenhuma divergência interior de piso; tolerância de antialias de 1 pixel. Essas evidências continuam válidas porque o runtime não mudou na r2. Conforto e leitura de subida/descida exigem relato humano.

## Portagem, referências e próximo checkpoint

Pacote local atualizado com os 18 arquivos e hashes, pendente de aprovação para aplicação na origem: ${base}/s004-portage-r2.json. Os hashes dos 17 caminhos da origem real foram comparados ao baseline e continuam iguais; não houve escrita na origem, sincronização, commit ou publicação. Fixtures pertencem somente à cópia sintética.

O contrato r1 é complementado pelo ajuste r2 aprovado, com teto 18. Estado reconciliado em map_path_revision_proposal, preservando demais planos e o cursor Dagruve CP-DAG-005, cujo feedback continua pendente. S-PATH-005 ainda não foi autorizada nem aberta. Entrada: build r2 validada e cenários sintéticos; saída: dois relatos humanos explícitos. Checks de Yggdrasil: espessura, variedade entre sementes, alternativas, bordas e congestionamento. Checks do Abismo: espiral, alternativas, orientação/subida-descida, bordas e combate. Próximo checkpoint CP-PATH-005: autorizar abertura dos playtests isolados dos dois mapas, com build/controles/objetivos apresentados antes da abertura.
`);
const spec='.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/validation-adjustment-r2-draft.md';fs.appendFileSync(spec,'\n## Verificação r2\n\nAplicação exata e suíte nativa aprovadas no PC e na candidata sintética. S-PATH-004 concluída, 12/12 suítes consolidadas, desempenho mantido e teto18 respeitado. Evidência: '+evidence+'. S-PATH-005 continua pendente de autorização própria.\n');
fs.appendFileSync('.atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/contract-r1.md','\n## Entrega S-PATH-004 e ajuste r2\n\nO titular aprovou o ajuste validation-adjustment-r2-draft.md, elevando o teto17→18 somente para tests/test_map_objectives.gd. Etapa técnica concluída com 12/12 suítes PC, teste de objetivos também na candidata sintética e desempenho dentro dos limites originais. Evidência: '+evidence+'. S-PATH-005 permanece pendente de autorização e dois aceites humanos.\n');
let state=fs.readFileSync('.atena/state/plan.yaml','utf8');const a=state.indexOf('map_path_revision_proposal:'),m=/\n[a-zA-Z_][a-zA-Z0-9_]*:/.exec(state.slice(a)),b=m?a+m.index:state.length;let block=state.slice(a,b);
const fields={status:'S_PATH_004_COMPLETE_AWAITING_S_PATH_005',completed_steps:'4',checkpoint:'CP-PATH-005',implementation_authorized:'false',next_activity:'Autorizar playtests isolados de Yggdrasil e primeira incursao abissal',next_step_approval:'PENDING_S_PATH_005_ONLY',next_step:'S-PATH-005',used_game_test_paths:'18',authorized_game_test_path_budget:'18',s004_evidence:evidence,s004_build:base+'/s004-build-r2.json',s004_native_suites:'12_OF_12_PASS',scope_adjustment_approval:'APPROVED_OWNER_R2_18TH_FILE_IMPLEMENTED'};
for(const[k,v]of Object.entries(fields))block=block.replace(new RegExp('^  '+k+':.*$','m'),'  '+k+': '+v);
block+='  s004_validation: '+base+'/s004-final-validation-r2.json\n  s004_portage: '+base+'/s004-portage-r2.json\n  s004_completed_checkpoint: CP-PATH-004-R2\n';state=state.slice(0,a)+block+state.slice(b);state=state.replace(/path_revision_suspension: ACTIVE_S_PATH_004_R2_RETURN_CURSOR_PRESERVED/g,'path_revision_suspension: CLOSED_AT_S_PATH_004_CHECKPOINT_RETURN_CURSOR_PRESERVED');fs.writeFileSync('.atena/state/plan.yaml',state);
for(const p of [report.build,report.authorization,report.evidence,report.portage,report.performance.comparison,report.support_parity.path,...report.render_sessions.map(p=>p+'/render-result.json')])check(fs.existsSync(p),'Missing reference '+p);
write(base+'/s004-reconciliation-r2.json',{status:'PASS',state_updated_from_fresh_read:true,referenced_artifacts_exist:true,game_test_paths:18,original_17_hashes_unchanged:true,objective_exact_approved_hash:true,performance_raw_hashes_verified:true,real_origin_baseline_unchanged:true,checkpoint:'CP-PATH-005',human_playtest_authorized:false});
console.log(JSON.stringify({status:'PASS',suites:'12/12',budget:'18/18',performance:'PASS_REUSED_HASH_VERIFIED',evidence,next:'CP-PATH-005'}));
