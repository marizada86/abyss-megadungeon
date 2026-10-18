from pathlib import Path
import hashlib, json

root = Path.cwd()
state = root / '.atena/state/plan.yaml'
text = state.read_text(encoding='utf-8')
text = text.replace('    status: S_C1_004_COMPLETE_S_C1_005_AUTHORIZATION_PENDING', '    status: S_C1_005_REGRESSION_IN_PROGRESS', 1)
anchor = '    integration_delivery: .atena/generated/chapter1-integration-20261017/delivery-r1.json'
assert anchor in text
text = text.replace(anchor, anchor + "\n    regression_authorization: 'autorizado (2026-10-17), S-C1-005: regressão ampliada com perfis sintéticos'\n    regression_authorized: true", 1)
text = text.replace("    next_activity: 'Autorizar S-C1-005, matriz ampliada de interrupção, legado e entrada; playtest depois'", "    next_activity: 'Executar S-C1-005: persistência por quadro, legado e entrada; S-C1-006 permanece pendente'", 1)
state.write_text(text, encoding='utf-8')
paths = ['core/chapter_flow.gd','core/profile.gd','core/game.gd','core/controller_input.gd','ui/hq_screen.gd','ui/run.gd','data/chapter_flow.json','data/hqs.json']
(root / '.atena/generated/chapter1-integration-20261017/regression-baseline-r1.json').write_text(json.dumps({p: hashlib.sha256((root/p).read_bytes()).hexdigest() for p in paths}, indent=2),encoding='utf-8')
