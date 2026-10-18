const fs=require('fs'),path=require('path'),crypto=require('crypto');
const read=p=>fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'');
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const base='.atena/generated/domwieck-art-20261017/';
const refs=[
 {manifest:'.atena/generated/hq18-production-20261017/hq18-sequence-r1.json',panel:3,asset:'assets/hq/chapter1_r1/hq_n18_q3_domwieck_invasion_v01.png',role:'Architecture, paving, active blue Tarn; exclude abyss/portal/troops'},
 {manifest:'.atena/generated/hq03-production-20261017/hq03-sequence-r1.json',panel:1,asset:'assets/hq/chapter1_r1/hq_n03_q1_garden_v03.png',role:'Circular forest, red garden, intact star and beam'},
 {manifest:'.atena/generated/hq03-production-20261017/hq03-sequence-r1.json',panel:2,asset:'assets/hq/chapter1_r1/hq_n03_q2_adam_strike_v03.png',role:'Only Ailalore material, larger scale and light blue; exclude Adam, strike and collapse'}
];
for(const ref of refs){
 const manifest=JSON.parse(read(ref.manifest));
 const panel=manifest.panels.find(p=>p.panel===ref.panel);
 if(!panel || !manifest.status.includes('APPROVED')) throw Error('Reference authority missing');
 ref.source=panel.path;ref.sha256=hash(ref.asset);
 if(hash(panel.path)!==panel.sha256 || ref.sha256!==panel.sha256)throw Error('Reference mismatch '+ref.asset);
 const bytes=fs.readFileSync(ref.asset);ref.width=bytes.readUInt32BE(16);ref.height=bytes.readUInt32BE(20);
 ref.visually_inspected=true;ref.authority='CANON_APPROVED_SEQUENCE_R1';ref.future_generation_authorization='PENDING_CP_DART_002';
}
const guarded=['ui/ground.gd','ui/stages/domwieck.tscn','ui/stages/reino_abissal.tscn','core/terrain_layout.gd','core/battle.gd','core/hero.gd','core/enemy.gd','data/level_design.json','data/stages.json','data/root_navigation.json','data/root_art.json','core/chapter_flow.gd'].filter(p=>fs.existsSync(p)).map(p=>({path:p,sha256:hash(p)}));
const audit={status:'PASS_PLANNING_REFERENCES',date:'2026-10-17',references:refs,guarded_sources:guarded,prototype_capture:'.atena/generated/root-art-20261017/validation-20261017-193929-368/domwieck-1280x720-target.png',prototype_capture_visually_inspected:true,no_image_generation:true,no_game_source_edits:true};
fs.writeFileSync(base+'reference-audit-r1.json',JSON.stringify(audit,null,2)+'\n');
const evidence='.atena/evidence/EVID-NOTTGARD-DOMWIECK-ART-PLAN-20261017-r1.md';
fs.writeFileSync(evidence,`---\nid: EVID-NOTTGARD-DOMWIECK-ART-PLAN-20261017\nrevision: r1\nstatus: PLANNING_COMPLETE_AWAITING_OWNER_DIRECTION_APPROVAL\n---\n\n# Planejamento da arte de Domwieck\n\nPedido classificado PLAN_CHANGE_REQUEST: novo plano delimitado após fechamento do plano de raízes. Planejamento autorizado, modo por etapa reutilizado. S-DART-001 concluída, 1/5; quatro etapas restantes.\n\nLidos ADD/estado vigente, guia de jogos/visual, dossiê aceito, decisões de jardim/estrela, sequências aprovadas HQ18/HQ03, implementação visual atual e cena de Domwieck. HQ18 Q3 v01, HQ03 Q1 v03 e HQ03 Q2 v03 visualmente reinspecionadas; hashes das fontes e cópias no jogo idênticos aos manifestos CANON. Captura de santuário do protótipo também inspecionada. [Auditoria e baseline informativo](../generated/domwieck-art-20261017/reference-audit-r1.json).\n\nConstatações: calçamento e seis edifícios geométricos provisórios; jardim circular com flores vermelhas e árvores esquemáticas; estrela atualmente desenhada como ícone de cinco pontas, divergente da massa cristalina irregular das HQs. Essa constatação fundamenta a proposta, sem alterar o jogo. Ailalore mantém identidade nomeada; personagens novos N/A. HQ03 Q2 usada apenas para material/escala da estrela, não para antecipar ataque ou colapso.\n\n[Plano/bíblia DRAFT r1](../specs/SPEC-NOTTGARD-DOMWIECK-ART-20261017/plan-r1.md): duas amostras, até seis PNGs de conjunto, até 12 caminhos de integração e playtest próprio. Zero gaps BLOCKING para a proposta; qualidade/UV/oclusão/desempenho resolvíveis nas etapas; demais escopos diferidos. Nenhum recurso gerado, teste Godot executado, código alterado ou conteúdo promovido a CANON nesta etapa.\n\nPreservados planos compartilhados e aceite das raízes 5/5. CP-DART-002 aguarda aprovação da direção r1 e autorização explícita de imagegen com as três referências delimitadas.\n`);
const statePath='.atena/state/plan.yaml';const before=read(statePath);
if(before.includes('\ndomwieck_art_plan:'))throw Error('Plan already exists; reconcile');
if(!before.startsWith('version: 2'))throw Error('Unexpected state contract');
const newBlock=`domwieck_art_plan:\n  id: PLAN-NOTTGARD-DOMWIECK-ART-20261017\n  revision: r1\n  classification: PLAN_CHANGE_REQUEST\n  status: S_DART_001_COMPLETE_AWAITING_CP_DART_002\n  mode: per-step\n  mode_basis: 'Aprovação por etapa já escolhida no fluxo de mapas e arte'\n  current_step: S-DART-001\n  completed_steps: 1\n  total_steps: 5\n  next_step: S-DART-002\n  checkpoint: CP-DART-002\n  approval: PLANNING_ONLY\n  authorization: 'Atena, vamos planejar a arte final de Domwieck, usando as HQs como referência. (2026-10-17)'\n  spec: .atena/specs/SPEC-NOTTGARD-DOMWIECK-ART-20261017/plan-r1.md\n  evidence: EVID-NOTTGARD-DOMWIECK-ART-PLAN-20261017-r1\n  reference_audit: .atena/generated/domwieck-art-20261017/reference-audit-r1.json\n  direction_status: DRAFT_R1_AWAITING_OWNER_APPROVAL\n  planning_authorized: true\n  production_authorized: false\n  implementation_authorized: false\n  remote_reference_use_authorized: false\n  proposed_reference_scope: HQ18_Q3_V01_HQ03_Q1_V03_HQ03_Q2_V03_LIMITED_ROLES\n  blocking_design_gaps: 0\n  next_step_approval: PENDING_S_DART_002\n  next_activity: 'Aprovar direção r1 e autorizar duas amostras com três referências delimitadas'\n  shared_state_policy: 'Preservar demais planos, campanha integrada e raízes concluídas 5/5'\n\n`;
const newline=before.indexOf('\n');
const after=before.slice(0,newline+1)+newBlock+before.slice(newline+1);
fs.writeFileSync(statePath,after);
if(read(statePath).replace(newBlock,'')!==before)throw Error('Shared state mismatch');
for(const p of ['add.yaml','state/plan.yaml','vault/canon','vault/drafts','vault/research','specs','evidence','generated'])if(!fs.existsSync('.atena/'+p))throw Error('ADD contract missing '+p);
let links=0;
for(const p of [evidence,'.atena/specs/SPEC-NOTTGARD-DOMWIECK-ART-20261017/plan-r1.md']){
 for(const m of read(p).matchAll(/\]\(([^)]+)\)/g)){if(!fs.existsSync(path.resolve(path.dirname(p),m[1])))throw Error('Missing link '+m[1]);links++;}
}
for(const p of guarded)if(hash(p.path)!==p.sha256)throw Error('Game file changed '+p.path);
const result={status:'PASS_DOCUMENTARY',stage:'S-DART-001',completed_steps:1,total_steps:5,reference_hashes_verified:3,document_links_verified:links,add_contract_valid:true,shared_state_preserved:true,game_sources_unchanged:true,blocking_gaps:0,next_checkpoint:'CP-DART-002'};
fs.writeFileSync(base+'plan-validation-r1.json',JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result));
