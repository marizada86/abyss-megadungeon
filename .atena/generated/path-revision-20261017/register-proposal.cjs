const fs=require('fs');
const file='.atena/state/plan.yaml';
const key='map_path_revision_proposal:';
const s=fs.readFileSync(file,'utf8');
if(s.includes(key)) throw Error('Proposal already registered; inspect current state');
const block=`
map_path_revision_proposal:
  id: PLAN-NOTTGARD-PATH-REVISION-20261017
  revision: r1
  classification: PLAN_CHANGE_REQUEST
  status: DRAFT_AWAITING_DIRECTION_APPROVAL
  mode: per-step
  mode_basis: Reutilizado do fluxo de mapas escolhido pelo titular
  ordered_steps: [S-PATH-001, S-PATH-002, S-PATH-003, S-PATH-004, S-PATH-005]
  current_step: S-PATH-001
  completed_steps: 0
  total_steps: 5
  checkpoint: CP-PATH-DIRECTION
  planning_authorized: true
  implementation_authorized: false
  generation_authorized: false
  spec: .atena/specs/SPEC-NOTTGARD-PATH-REVISION-20261017/proposal-r1.md
  next_activity: Aprovar direcao e detalhar contrato S-PATH-001
  next_step_approval: PENDING_DIRECTION_AND_S_PATH_001
  dagruve_feedback: STILL_PENDING_NO_ACCEPTANCE_INFERRED
  return_policy: Persistir suspensao e cursor atualizado antes de execucao aprovada
  shared_state_policy: Preservar planos concluidos e HQs concorrentes
`;
fs.writeFileSync(file,s.trimEnd()+'\n'+block);
console.log('DRAFT proposal registered; runtime unchanged; existing state preserved.');
