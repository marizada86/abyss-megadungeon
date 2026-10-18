const fs=require('fs'),path=require('path'),crypto=require('crypto');const dir=__dirname;
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');const refs=[];
for(const [file,panels] of [['.atena/generated/hq17-production-20261016/hq17-sequence-r1.json',[1,3,4]],['.atena/generated/hq16-production-20261016/hq16-sequence-r1.json',[5]]]){
 const manifest=JSON.parse(fs.readFileSync(file,'utf8').replace(/^\uFEFF/,''));
 for(const panel of manifest.panels.filter(p=>panels.includes(p.panel))){if(!fs.existsSync(panel.path)||!fs.existsSync(panel.individual_approval))throw Error('Missing approved reference');const actual=hash(panel.path);if(actual!==panel.sha256)throw Error('Reference hash mismatch');refs.push({hq:manifest.hq,panel:panel.panel,path:panel.path,sha256:actual,approval:panel.individual_approval,authority:'CANON_APPROVED_REFERENCE',visually_inspected:true});}
}
const docs=['.atena/specs/SPEC-NOTTGARD-ROOT-ART-20261017/plan-r1.md','.atena/evidence/EVID-NOTTGARD-ROOT-ART-PLAN-20261017-r1.md'];for(const p of docs)for(const m of fs.readFileSync(p,'utf8').matchAll(/\]\(([^)]+)\)/g))if(!m[1].includes('://')&&!fs.existsSync(path.resolve(path.dirname(p),m[1])))throw Error('Broken doc link '+m[1]);
const sources=['data/root_navigation.json','core/iso.gd','core/terrain_layout.gd','ui/ground.gd','project.godot','.atena/vault/canon/DEC-NOTTGARD-ROOT-PLAYTEST-APPROVED-20261017-r1.md'].map(p=>({path:p,sha256:hash(p)}));
fs.writeFileSync(dir+'/reference-audit.json',JSON.stringify({status:'PASS',refs,sources,production_authorized:false,document_links_valid:true},null,2));
const p='.atena/state/plan.yaml',s=fs.readFileSync(p,'utf8');if(s.includes('\nroot_art_plan:'))throw Error('Plan already exists; reconcile instead of replacing');const at=s.indexOf('\n')+1;const section=`root_art_plan:
  id: PLAN-NOTTGARD-ROOT-ART-20261017
  revision: r1
  classification: PLAN_CHANGE_REQUEST
  status: S_RART_001_COMPLETE_AWAITING_CP_RART_002
  mode: per-step
  mode_basis: 'Mesmo fluxo de mapas/raízes; aprovação por etapa já escolhida'
  current_step: S-RART-001
  completed_steps: 1
  total_steps: 5
  next_step: S-RART-002
  checkpoint: CP-RART-002
  approval: PENDING_R1_DIRECTION_AND_SAMPLE
  authorization: 'Atena, vamos planejar a arte final das raízes do Reino Abissal, usando as HQs como referência. (2026-10-17)'
  spec: .atena/specs/SPEC-NOTTGARD-ROOT-ART-20261017/plan-r1.md
  evidence: EVID-NOTTGARD-ROOT-ART-PLAN-20261017-r1
  reference_audit: .atena/generated/root-art-20261017/reference-audit.json
  planning_authorized: true
  production_authorized: false
  implementation_authorized: false
  remote_reference_use_authorized: false
  blocking_design_gaps: 0
  prerequisite: 'Navegação r2 concluída e aceita; preservar geometria e espaço de combate'
  next_activity: 'Aprovar direção r1 e S-RART-002: amostra imagegen usando somente HQ17 Q3/Q4, sem admissão em assets'
  shared_state_policy: 'Planos de mapas/campanha/HQs preservados; reler estado vigente antes de cada checkpoint'
`;
fs.writeFileSync(p,s.slice(0,at)+section+s.slice(at));const updated=fs.readFileSync(p,'utf8');if(updated.slice(at+section.length)!==s.slice(at))throw Error('Shared state mismatch');
console.log('PASS: 4 approved HQ references verified; links valid; planning 1/5; production pending; existing state preserved.');
