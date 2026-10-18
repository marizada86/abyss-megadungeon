const fs = require('fs');
const crypto = require('crypto');
const base = '.atena/generated/root-art-20261017/';
const read = p => fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'');
const technical = JSON.parse(read(base+'s004-final-validation.json'));
const launch = JSON.parse(read(base+'s005-launch.json'));
if (!technical.tests.every(t=>t.passed) || technical.render_audit.failures.length || !launch.isolated || launch.errors.length) throw Error('Prerequisite evidence failed');
for (const entry of technical.changed_sources) {
 const hash = crypto.createHash('sha256').update(fs.readFileSync(entry.path)).digest('hex');
 if (hash !== entry.sha256) throw Error('Technical evidence requires reconciliation: '+entry.path);
}
const statePath='.atena/state/plan.yaml';
const state=read(statePath);
const boundary=state.indexOf('\nroot_navigation_revision:');
if(boundary<0) throw Error('Missing state boundary');
const preserved=state.slice(boundary);
let block=state.slice(0,boundary);
if(!block.includes('status: S_RART_005_ACTIVE_AWAITING_OWNER_FEEDBACK')) throw Error('Unexpected checkpoint');
const evidence='.atena/evidence/EVID-NOTTGARD-ROOT-ART-PLAYTEST-ACCEPTANCE-20261017-r1.md';
const canon='.atena/vault/canon/ASSET-APPROVAL-ROOT-ART-INTEGRATED-R1-20261017-r1.md';
const spec='.atena/specs/SPEC-NOTTGARD-ROOT-ART-20261017/plan-r1.md';
const quote='Atena, testei e aprovei o visual das raízes. Pode concluir a S-RART-005 e registrar o resultado do playtest.';
for (const p of [evidence,canon,base+'s005-final-validation.json']) if(fs.existsSync(p)) throw Error('Existing result: '+p);
fs.writeFileSync(evidence,`---\nid: EVID-NOTTGARD-ROOT-ART-PLAYTEST-ACCEPTANCE-20261017\nrevision: r1\nstatus: COMPLETE_OWNER_APPROVED\n---\n\n# Playtest visual das raízes — aceite final\n\nEm 2026-10-17, após o playtest isolado do Reino Abissal com a arte integrada r1, o usuário declarou:\n\n> ${quote}\n\nResultado: visual das raízes aprovado pelo usuário, sem solicitação de ajuste nesta devolutiva. A avaliação subjetiva pendente da S-RART-005 foi resolvida pelo aceite humano. Não foram fornecidas observações individuais por critério nem duração da sessão; não se inventam esses dados.\n\nEscopo aceito: aplicação do conjunto r1 (superfície, junções, laterais e profundidade) nas raízes do Reino Abissal para Windows x86_64, com referências de produção limitadas a HQ17 Q3 v02 e Q4 v01. Navegação, bordas travadas, caminhos e espaço de combate mantêm o aceite anterior.\n\nEvidências de execução: [abertura isolada](EVID-NOTTGARD-ROOT-ART-PLAYTEST-LAUNCH-20261017-r1.md), [registro da sessão](../generated/root-art-20261017/s005-launch.json) e [integração técnica](EVID-NOTTGARD-ROOT-ART-INTEGRATION-20261017-r1.md). Sete testes aprovados, auditoria gráfica e comparação técnica reutilizados; hashes dos oito arquivos de jogo/teste conferidos novamente e idênticos aos da validação S-RART-004. Sem alteração de jogo neste fechamento, sem repetição dos testes. Os registros anteriores com aceite pendente permanecem como histórico.\n\nReconciliação: S-RART-005 e CP-RART-005 concluídos; plano r1 encerrado com 5/5 etapas, zero restantes e nenhum checkpoint pendente neste plano. [Aceite CANON delimitado](../vault/canon/ASSET-APPROVAL-ROOT-ART-INTEGRATED-R1-20261017-r1.md). Outros planos preservados. Arte de outros ambientes, demais elementos decorativos, efeitos, Web e publicação continuam fora do escopo. Nenhuma nova etapa iniciada.\n`);
fs.writeFileSync(canon,`---\nid: ASSET-APPROVAL-ROOT-ART-INTEGRATED-R1-20261017\nrevision: r1\nstatus: CANON_OWNER_APPROVED_INTEGRATED_VISUAL\n---\n\n# Reino Abissal — arte integrada das raízes aprovada\n\nO usuário aprovou explicitamente o visual integrado das raízes r1 após jogar em 2026-10-17:\n\n> ${quote}\n\nAceite restrito ao conjunto r1 aplicado ao Reino Abissal no PC Windows x86_64: superfície, junções, laterais e profundidade; fontes e hashes no [aceite do conjunto](ASSET-APPROVAL-ROOT-ART-KIT-R1-20261017-r1.md). Referências de produção: somente HQ17 Q3 v02 e Q4 v01. Implementação identificada pelos hashes em [validação técnica](../../generated/root-art-20261017/s004-final-validation.json), reconferidos no fechamento.\n\n[Resultado do playtest](../../evidence/EVID-NOTTGARD-ROOT-ART-PLAYTEST-ACCEPTANCE-20261017-r1.md). Aprovação conclui S-RART-005 e plano r1 em 5/5. Preserva o aceite anterior de navegação r2; não promove a bíblia DRAFT em bloco nem acrescenta lore, mapas ou escopo de publicação.\n`);
let specText=read(spec);
specText=specText.replace('status: INTEGRATED_TECHNICAL_PASS_AWAITING_CP_RART_005','status: COMPLETE_OWNER_APPROVED_R1');
specText+=`\n\n## Conclusão S-RART-005 — 2026-10-17\n\nO usuário informou que testou e aprovou o visual integrado das raízes, autorizando o registro e fechamento. [Resultado do playtest](../../evidence/EVID-NOTTGARD-ROOT-ART-PLAYTEST-ACCEPTANCE-20261017-r1.md) e [aceite CANON delimitado](../../vault/canon/ASSET-APPROVAL-ROOT-ART-INTEGRATED-R1-20261017-r1.md). **5/5 etapas concluídas; zero restantes; CP-RART-005 encerrado.** Aceite visual humano recebido; hashes dos oito arquivos de jogo/teste idênticos à validação técnica. Sete testes e auditorias anteriores reutilizados, sem alteração de jogo neste fechamento. Referências anteriores a pendências de autorização, produção, integração ou aceite são históricas e estão resolvidas pelos registros de execução e aceite deste plano. Escopos DEFERRED permanecem fora deste plano; nenhuma nova etapa iniciada.\n`;
block=block.replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN')
 .replace('status: S_RART_005_ACTIVE_AWAITING_OWNER_FEEDBACK','status: COMPLETE_OWNER_APPROVED_R1')
 .replace('completed_steps: 4','completed_steps: 5')
 .replace('next_step: S-RART-005','next_step: null')
 .replace('approval: APPROVED_S_RART_005_ISOLATED_VISUAL_PLAYTEST','approval: APPROVED_S_RART_005_OWNER_VISUAL_ACCEPTANCE')
 .replace("next_activity: 'Executar playtest visual isolado e aguardar avaliação do usuário'","next_activity: 'Plano concluído; nenhuma etapa restante neste escopo'")
 .replace('completed_checkpoint: CP-RART-004','completed_checkpoint: CP-RART-005')
 .replace('next_step_approval: APPROVED_S_RART_005','next_step_approval: NOT_APPLICABLE_PLAN_COMPLETE')
 .replace('visual_playtest: OPEN_AWAITING_OWNER_FEEDBACK','visual_playtest: COMPLETE_OWNER_APPROVED');
block+=`  visual_playtest_acceptance: "${quote} (2026-10-17)"\n  visual_playtest_acceptance_evidence: EVID-NOTTGARD-ROOT-ART-PLAYTEST-ACCEPTANCE-20261017-r1\n  visual_playtest_acceptance_canon: ${canon}\n  final_validation: ${base}s005-final-validation.json\n`;
fs.writeFileSync(spec,specText);
fs.writeFileSync(statePath,block+preserved);
if(read(statePath).slice(read(statePath).indexOf('\nroot_navigation_revision:'))!==preserved) throw Error('Shared state changed');
for(const path of [evidence,canon,spec,base+'s004-final-validation.json',base+'s005-launch.json']) {
 if(!fs.existsSync(path)) throw Error('Broken reference '+path);
}
for(const path of [evidence,canon,spec]) {
 for(const match of read(path).matchAll(/\]\(([^)]+)\)/g)) {
  const link=match[1];
  if(/^[a-z]+:|^#/.test(link)) continue;
  const resolved=require('path').resolve(require('path').dirname(path),link.split('#')[0]);
  if(!fs.existsSync(resolved)) throw Error('Broken document link '+link);
 }
}
const result={status:'COMPLETE_OWNER_APPROVED_R1',stage:'S-RART-005',completed_steps:5,total_steps:5,remaining_steps:0,completed_checkpoint:'CP-RART-005',owner_acceptance:quote,evidence,canon,technical_validation:base+'s004-final-validation.json',game_test_source_hashes_unchanged:true,prior_checks_reused:true,shared_state_preserved:true,document_links_valid:true,game_sources_changed_this_step:false,recorded_utc:new Date().toISOString()};
fs.writeFileSync(base+'s005-final-validation.json',JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify(result,null,2));
