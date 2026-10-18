const fs = require('fs');
const p = '.atena/state/plan.yaml';
let text = fs.readFileSync(p, 'utf8');
const end = text.indexOf('\nroot_navigation_revision:');
if (end < 0) throw new Error('Shared state boundary missing');
let block = text.slice(0, end);
if (!block.includes('status: S_RART_004_COMPLETE_AWAITING_CP_RART_005')) throw new Error('Unexpected checkpoint');
block = block.replace('status: S_RART_004_COMPLETE_AWAITING_CP_RART_005', 'status: S_RART_005_ACTIVE_AWAITING_OWNER_FEEDBACK')
 .replace('current_step: S-RART-004', 'current_step: S-RART-005')
 .replace('approval: APPROVED_S_RART_004_INTEGRATION_AND_ISOLATED_CHECKS', 'approval: APPROVED_S_RART_005_ISOLATED_VISUAL_PLAYTEST')
 .replace("next_activity: 'Autorizar S-RART-005: playtest visual isolado e aceite final da arte integrada'", "next_activity: 'Executar playtest visual isolado e aguardar avaliação do usuário'")
 .replace('next_step_approval: PENDING_S_RART_005', 'next_step_approval: APPROVED_S_RART_005')
 .replace('visual_playtest: PENDING_OWNER_AUTHORIZATION', 'visual_playtest: AUTHORIZED_AWAITING_LAUNCH');
block += '\n  visual_playtest_authorization: "autorizado (2026-10-17), em resposta à abertura da S-RART-005 e do playtest visual isolado"\n';
fs.writeFileSync(p, block + text.slice(end));
fs.writeFileSync('.atena/generated/root-art-20261017/s005-start.json', JSON.stringify({authorized:true,started_utc:new Date().toISOString(),stage:'S-RART-005',completed_steps:4,total_steps:5},null,2)+'\n');
console.log('S-RART-005 authorized; shared state preserved.');
