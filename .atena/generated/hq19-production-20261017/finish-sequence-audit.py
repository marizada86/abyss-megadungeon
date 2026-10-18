from pathlib import Path
import json,yaml
r=Path.cwd(); base=r/'.atena/generated/hq19-production-20261017'
p=base/'approved-sequence-r1.json'; m=json.loads(p.read_text(encoding='utf-8'))
m.update(status='COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED',visual_sequence_inspection='PASS_ATENA_CONTACT_SHEET',sequence_checks=dict(ordered_12_panels=True,before_after_dagruve_split=True,aila_wingless=True,brook_receives_hammer=True,kayron_white=True,roots_fail_before_later_maelor_transfer=True,thalion_survives_aila_retained=True),runtime_verified=False)
p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ19-VISUAL-SEQUENCE-20261017-r1.md'
(r/evidence).write_text('''# HQ19 — fechamento de produção visual r1

Estado: COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED. Doze quadros com aceites individuais do dono, roteiro CANON r2 e seleção visual r1 preservados. Manifesto: .atena/generated/hq19-production-20261017/approved-sequence-r1.json. Prancha: hq19-approved-sequence-r1.jpg na mesma pasta.

Checks: 12 PNGs íntegros, dimensões 1672×941, hashes correspondentes aos registros; prompts e aceites presentes. Inspeção visual da prancha em ordem Q1–12: liberação de Aila precede despertar, legado do martelo a Brook, Aila sem asas, divisão Q1–4 antes/Q5–12 após Dagruve; Kayron branco e Brook em cenas distintas, falha inicial das raízes antes da captura física e posterior envio de Maelor; Thalion vivo e Aila retida no encerramento. Nenhuma correção adicional identificada nesta inspeção da sequência. Aceites anteriores preservados.

Limites: inspeção de imagens estáticas, não playtest ou validação de legendas no leitor. Nenhum arquivo admitido no runtime, gatilho alterado ou publicação efetuada. Produção visual HQ19 concluída; integração permanece checkpoint próprio. Próxima HQ editorial: HQ20, cuja seleção visual ainda precisa ser preparada antes de candidata.
''',encoding='utf-8')
state=r/'.atena/state/plan.yaml'; t=state.read_text(encoding='utf-8'); a=t.index('  hq19_visual_selection:\n'); b=t.index('  chapter_2_review:\n',a); block=t[a:b]
block=block.replace('visual_production_status: TWELVE_INDIVIDUAL_APPROVALS_FILES_VERIFIED','visual_production_status: COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED',1).replace("next_activity: 'Conferência final visual HQ19; 12/12 com aceites individuais'","next_activity: 'HQ19 produção visual concluída; integração pendente de checkpoint próprio'",1)
block+=f'    visual_sequence_evidence: {evidence}\n    visual_sequence_inspection: PASS_ATENA_CONTACT_SHEET\n'
t=t[:a]+block+t[b:]; yaml.safe_load(t); state.write_text(t,encoding='utf-8')
print('PASS: produção visual HQ19 concluída, 12/12 aceites e sequência conferida; integração pendente.')
