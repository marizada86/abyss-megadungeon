from pathlib import Path
import json,sys,yaml
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();base=root/'.atena/generated/source-port-20261018';out=base/'b002'
load=lambda p:json.loads(p.read_text(encoding='utf-8'))
verification=load(out/'verification-r1.json');state=yaml.safe_load((root/'.atena/state/plan.yaml').read_text(encoding='utf-8-sig'));plan=state['source_port_20261018_proposal']
assert plan['mode']=='per-batch' and plan['completed_steps']==4 and plan['checkpoint']=='CP-PORT-B003-APPROVAL'
assert plan['authorized_batches']==['B-PORT-001','B-PORT-002'] and plan['implementation_authorized'] is False
assert state['hq05_visual_production_plan']['checkpoint']=='CP-V05-01' and state['hq05_visual_production_plan']['status']=='SELECTION_R1_AWAITING_OWNER_APPROVAL'
for key in ['spec','integration_contract','baseline_debts','b001_evidence','b002_evidence','b002_verification','b002_final_write_set']:assert (root/plan[key]).is_file(),key
final=load(out/'final-write-set.json')
for r in final:
 if r['operation']=='COPY_SOURCE' and r['after_sha256']!=r['source_sha256']:r['operation']='COPY_SOURCE_ADAPTED_FOR_PC_B002'
(out/'final-write-set.json').write_text(json.dumps(final,ensure_ascii=False,indent=2),encoding='utf-8')
admission=load(out/'admission-r1.json');admission.update(status='B002_COMPLETE_TECHNICAL_DELIVERY_DRAFT_GATES_PRESERVED',write_set=final,verification='.atena/generated/source-port-20261018/b002/verification-r1.json')
(out/'admission-r1.json').write_text(json.dumps(admission,ensure_ascii=False,indent=2),encoding='utf-8')
features=load(base/'b001/functional-matrix.json')
for f in features:
 id=f['id']
 f['integration_status']='B003_PENDING' if id not in ['F-PORT-005','F-PORT-006','F-PORT-007','F-PORT-009','F-PORT-012'] else {'F-PORT-005':'B002_TECHNICAL_PASS_DRAFT_HUMAN_GATES_PENDING','F-PORT-006':'B002_INTEGRATED_VISUALS_RETAINED_IDLE_GATES_PRESERVED','F-PORT-007':'B002_EXISTING_VFX_CONNECTED_FUTURE_EVOLUTION_GAMEPLAY_B003','F-PORT-009':'B002_ASSETS_READERS_READY_UI_OPTIONS_THEME_ACTIVATION_B003','F-PORT-012':'PC_CONTENT_PRESERVED_163_PROTECTED_PATHS_VERIFIED'}[id]
(out/'functional-matrix-r2.json').write_text(json.dumps(features,ensure_ascii=False,indent=2),encoding='utf-8')
report={'status':'B002_COMPLETE_AWAITING_B003_APPROVAL','completed_steps':4,'total_steps':8,'completed_batches':2,'total_batches':4,'next_checkpoint':plan['checkpoint'],'next_batch_authorized':False,'portage_registered':True,'source_unchanged':verification['source_original_unchanged'],'protected_paths':verification['protected_pc_paths_verified'],'copied_asset_files':394,'png_files':201,'targeted_tests_pass':18,'native_checks_pass':37,'retentions_and_draft_preserved':True,'hq05_return_preserved':True,'remaining_pc_baseline_debts':'30 assertions and 2 script errors; native GL teardown messages separately recorded','canon_promoted':False,'real_save_access':False,'commit_push_export':False}
(out/'closeout-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(report,ensure_ascii=False,indent=2))
