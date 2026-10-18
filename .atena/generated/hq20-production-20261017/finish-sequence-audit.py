from pathlib import Path
import json,re,yaml
r=Path.cwd(); base=r/'.atena/generated/hq20-production-20261017'
p=base/'approved-sequence-r1.json'; m=json.loads(p.read_text(encoding='utf-8'))
m.update(status='COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED',visual_sequence_inspection='PASS_ATENA_CONTACT_SHEET',sequence_checks=dict(correct_yggdrasil_q1_v03=True,marciela_official_q2_q3_q7=True,two_routes_no_simultaneous_arrival_claim=True,nidhogg_alive_maelor_unharmed=True,portal_purple=True,mother_reunion_no_aila=True),runtime_verified=False)
p.write_text(json.dumps(m,ensure_ascii=False,indent=2),encoding='utf-8')
evidence='.atena/evidence/EVID-NOTTGARD-HQ20-VISUAL-SEQUENCE-20261017-r1.md'
(r/evidence).write_text('''# HQ20 — fechamento da produção visual r1

COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED. Sete de sete quadros com aceites individuais. Manifesto approved-sequence-r1.json e prancha hq20-approved-sequence-r1.jpg em .atena/generated/hq20-production-20261017/.

Seleção final: Q1 v03 correta de madeira robusta; Q2 v02 e Q3 v02 com pacote aprovado de Marciela; Q4 v01 já aceita no outro plano; Q5/Q6/Q7 v01 aceitas neste fluxo. Versões antigas e aceites históricos preservados. Arquivos, hashes, PNGs, proporções e referências dos registros de aceite conferidos. Q4 original 1672×940, demais 1672×941; nenhum redimensionamento dos originais.

Prancha inspecionada em ordem: chegada Leoric/Korrak, encontro Marciela, passagem roxa; corte para Maelor isolado, Nidhogg cobra gigante erra mordida, fuga até portal, reencontro com mãe no lado abissal. Madeira/cosmos coerentes Q1–6, visual Marciela coerente Q2/Q3/Q7; Maelor sem ferimentos, Nidhogg vivo, ausência de Aila. Não se estabelece simultaneidade das trajetórias nem duração objetiva de anos. Nenhuma correção adicional identificada nesta inspeção estática.

Sem integração, gatilhos, playtest ou teste de legendas no leitor. Plano de referências do mapa e planos concorrentes preservados. Integração permanece checkpoint próprio. Próxima HQ editorial na sequência é HQ21, que requer seleção visual antes de produzir.
''',encoding='utf-8')
p=r/'.atena/state/plan.yaml'; t=p.read_text(encoding='utf-8'); pattern=r'(?ms)^hq20_completion_production_plan:\n.*?(?=^[A-Za-z_][A-Za-z_0-9]*:|\Z)'; match=re.search(pattern,t); assert match
block=match.group().replace('status: SEVEN_INDIVIDUAL_APPROVALS_FILES_VERIFIED','status: COMPLETE_VISUAL_PRODUCTION_INDIVIDUALLY_APPROVED',1).replace('next_activity: Conferir visualmente sequência completa HQ20; 7/7 aceitas','next_activity: HQ20 produção visual concluída; integração pendente de checkpoint próprio',1)
block+=f'  sequence_inspection: PASS_ATENA_CONTACT_SHEET\n  sequence_evidence: {evidence}\n'
t=t[:match.start()]+block+t[match.end():]; yaml.safe_load(t); p.write_text(t,encoding='utf-8')
print('PASS: HQ20 produção visual concluída, 7/7 aceites, sequência conferida; sem integração.')
