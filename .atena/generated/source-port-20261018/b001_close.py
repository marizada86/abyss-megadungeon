from pathlib import Path
import json,sys,yaml
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();out=root/'.atena/generated/source-port-20261018/b001'
state=yaml.safe_load((root/'.atena/state/plan.yaml').read_text(encoding='utf-8-sig'))
plan=state['source_port_20261018_proposal'];assert plan['completed_steps']==2 and plan['mode']=='per-batch'
assert plan['authorized_batches']==['B-PORT-001'] and plan['checkpoint']=='CP-PORT-B002-APPROVAL'
for key in ['spec','evidence','b001_evidence','integration_contract','baseline_debts','b001_inventory','b001_conflicts']:
 assert (root/plan[key]).is_file(),key
assert state['hq05_visual_production_plan']['checkpoint']=='CP-V05-01'
assert state['hq05_visual_production_plan']['status']=='SELECTION_R1_AWAITING_OWNER_APPROVAL'
results={k:json.loads((out/('baseline-'+k)/'results.json').read_text(encoding='utf-8'))['results'] for k in ['source','pc']}
follow={k:json.loads((out/('baseline-'+k)/'followup-results.json').read_text(encoding='utf-8')) for k in ['source','pc']}
assert next(r for r in results['pc'] if r['name']=='suite')['script_errors']==2
assert len(next(r for r in results['pc'] if r['name']=='suite')['failures'])==30
assert all(r['engine_errors']==0 and r['script_errors']==0 and r['exit_code']==0 for rs in follow.values() for r in rs if r['name']=='warm-import')
mobile=next(r for r in follow['source'] if r['name']=='mobile-retry');assert mobile['exit_code']==0 and mobile['script_errors']==0 and any('146 verificacoes; 0 falha' in s for s in mobile['summaries'])
integrity=json.loads((out/'integrity-verification.json').read_text(encoding='utf-8'));assert integrity['runtime_unchanged']
report={'status':'B001_COMPLETE_WITH_PC_BASELINE_DEBTS','completed_steps':2,'total_steps':8,'next_gate':'CP-PORT-B002-APPROVAL','next_batch_authorized':False,'runtime_unchanged':True,'source_test_files':len(list((root/'tmp/port-b1/source/tests').glob('test_*.gd'))),'pc_test_files':len(list((root/'tmp/port-b1/pc/tests').glob('test_*.gd'))),'source_suite_assertion_failures':0,'pc_suite_assertion_failures':30,'pc_suite_script_errors':2,'smoke_stages':{'source':9,'pc':11},'synthetic_controller_checks':{'source':'94/0','pc':'94/0'},'source_mobile_retry':'146/0','known_teardown_errors_preserved':True,'cold_import_and_mobile_harness_attempts_recorded':True,'hq05_return_preserved':True,'new_canonical_content':False,'real_save_access':False,'export_commit_push':False}
(out/'closeout-r1.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps(report,indent=2,ensure_ascii=False))
