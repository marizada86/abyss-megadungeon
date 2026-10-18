const fs=require('fs'),crypto=require('crypto');
const d='.atena/generated/hq20-production-20261017/',text=p=>fs.readFileSync(p,'utf8'),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
fs.mkdirSync(d+'candidates',{recursive:true});
const audit=JSON.parse(text('.atena/generated/hq20-reference-selection-20261017/audit-r1.json'));
for(const e of audit.identities)if(hash(e.path)!==e.sha256)throw Error('Identity reference changed');
const canon='.atena/vault/canon/DEC-HQ20-REFERENCE-VISUAL-SELECTION-20261017-r1.md';
fs.writeFileSync(canon,'---\nid: DEC-HQ20-REFERENCE-VISUAL-SELECTION-20261017\nrevision: r1\nstatus: CANON_OWNER_SELECTION_APPROVED\n---\n\n# Seleção visual HQ20 r1 aprovada\n\nO usuário aprovou a seleção r1, incluindo Marciela de costas e em contraluz, e autorizou produzir somente uma candidata HQ20 Q1 com imagegen para aprovação antes dos demais quadros. [Seleção aceita](../../specs/SPEC-NOTTGARD-HQ20-REFERENCE-SELECTION-20261017/selection-r1.md). O enquadramento indireto não define rosto/identidade facial de Marciela. Q3/Q4 e integração permanecem sem autorização de produção. Candidata gerada não será automaticamente CANON.\n');
const p='.atena/state/plan.yaml',s=text(p),a=s.indexOf('\nhq20_reference_selection_plan:'),z=s.indexOf('\nyggdrasil_art_plan:');
let b=s.slice(a,z);if(a<0||z<0||!b.includes('status: DOCUMENTARY_COMPLETE_AWAITING_CP_V20_01'))throw Error('Checkpoint changed');
b=b.replace('status: DOCUMENTARY_COMPLETE_AWAITING_CP_V20_01','status: COMPLETE_OWNER_APPROVED_R1').replace('approval: DOCUMENTARY_PREPARATION_ONLY','approval: APPROVED_OWNER_VISUAL_SELECTION_R1').replace('selection_status: DRAFT_R1_AWAITING_OWNER_ACCEPTANCE','selection_status: APPROVED_OWNER_R1').replace('marciela: INDIRECT_BACKLIT_BACK_VIEW_PROPOSED_PENDING_ACCEPTANCE','marciela: INDIRECT_BACKLIT_BACK_VIEW_OWNER_APPROVED').replace(/  next_activity: [^\n]+/,"  next_activity: 'Selecao concluida; producao Q1 autorizada em plano proprio'");
b+='  acceptance_canon: '+canon+'\n';
const production=`\nhq20_reference_production_plan:
  id: PLAN-NOTTGARD-HQ20-REFERENCE-PRODUCTION-20261017
  revision: r1
  classification: IN_PLAN_REFERENCE_DEPENDENCY
  status: S_P20_Q01_GENERATING_ONLY_AUTHORIZED_PANEL
  mode: per-step
  current_step: S-P20-Q01
  completed_steps: 0
  total_steps: 3
  ordered_steps: [S-P20-Q01, S-P20-Q03, S-P20-Q04]
  next_step: S-P20-Q01
  checkpoint: CP-P20-Q01
  approval: AUTHORIZED_OWNER_Q1_ONLY
  authorization: 'Selecao r1 aprovada e autorizada somente candidata HQ20 Q1 com imagegen, 2026-10-17'
  generation_authorized: Q1_ONLY
  runtime_authorized: false
  spec: .atena/specs/SPEC-NOTTGARD-HQ20-REFERENCE-PRODUCTION-20261017/q1-r1.md
  output_directory: ${d}candidates
  next_activity: 'Gerar, conferir e apresentar Q1 para aceite; nao avancar a Q3/Q4'

`;
fs.writeFileSync(p,s.slice(0,a)+production+b+s.slice(z));
const sd='.atena/specs/SPEC-NOTTGARD-HQ20-REFERENCE-PRODUCTION-20261017/';fs.mkdirSync(sd,{recursive:true});
fs.writeFileSync(sd+'q1-r1.md','---\nid: SPEC-NOTTGARD-HQ20-REFERENCE-PRODUCTION-20261017\nrevision: r1\nstatus: AUTHORIZED_Q1_ONLY\norigin: planned\nimplementation_preceded_spec: false\napproval_mode: per-step\n---\n\n# Produção delimitada — HQ20 Q1\n\n[Seleção aprovada](../../vault/canon/DEC-HQ20-REFERENCE-VISUAL-SELECTION-20261017-r1.md). Executar S-P20-Q01, etapa1/3 do recorte Q1/Q3/Q4;0/3 aceites inicialmente, demais produções não autorizadas. Uma candidata Q1 com imagegen nativo e retratos Leoric/Korrak como referências; raiz colossal contínua e tronco aparentemente sem fim. Composição16:9, pixel art, sem texto/portal/terceiro personagem/machado posterior. Fontes vistas e hashes conferidos. Zero gaps BLOCKING.\n\nSaída versionada em .atena/generated/hq20-production-20261017/candidates/; preservar original e registrar prompt, ferramenta, dimensões/hash e revisão visual. Conferir diferença de escala gnomo/goliath, pés apoiados, topo/lateral e tronco monumental, ausência de armas posteriores, texto ou elementos de outras HQs. Candidata DRAFT aguardará aceite CP-P20-Q01 antes de autorizar Q3. Sem runtime, Godot, save, exportação ou publicação. Recuperação: preservar candidata anterior e produzir nova versão apenas se necessário; não substituir arquivos de outros chats.\n');
const selection='.atena/specs/SPEC-NOTTGARD-HQ20-REFERENCE-SELECTION-20261017/selection-r1.md';fs.writeFileSync(selection,text(selection).replace('status: DRAFT_AWAITING_OWNER_VISUAL_SELECTION_APPROVAL','status: APPROVED_OWNER_VISUAL_SELECTION_R1')+'\n\n## Aceite posterior\n\nUsuário aprovou expressamente seleção r1, incluindo Marciela em vista indireta, e autorizou somente Q1. Proposta DRAFT original acima é histórica; [decisão CANON](../../vault/canon/DEC-HQ20-REFERENCE-VISUAL-SELECTION-20261017-r1.md). Produção/aceite de Q3 e Q4 continuam com checkpoints próprios.\n');
fs.writeFileSync(d+'q1-inputs-r1.json',JSON.stringify({authorization:'Q1 only',references:audit.identities.filter(e=>e.id==='leoric'||e.id==='korrak'),selection_canon:canon,reference_roles:'Identity only, no portrait backgrounds or later axe',runtime_baseline:JSON.parse(text('.atena/generated/yggdrasil-art-20261017/reference-audit-r1.json')).game_baseline},null,2)+'\n');
console.log('Selection accepted; Q1-only production scope and checkpoint recorded');
