from pathlib import Path
import json,hashlib,re,sys
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();base=root/'.atena/generated/source-port-20261018';b=base/'b003';val=b/'validation';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None
old=load(base/'b001/pc-manifest.json');expected={k:v['sha256'] for k,v in old.items()};b2=load(base/'b002/final-write-set.json');rows=load(b/'write-set-r1.json')
for r in b2:expected[r['path']]=r['after_sha256']
before=dict(expected)
for r in rows:
 assert r['before_sha256']==before.get(r['path']),'before '+r['path']
 if r['before_sha256']:assert sha(b/'before'/r['path'])==r['before_sha256'],'backup '+r['path']
 assert sha(root/r['path'])==r['after_sha256'],'delivery drift '+r['path']
 assert sha(root/'tmp/port-b3/candidate'/r['path'])==r['after_sha256'],'candidate drift '+r['path']
 expected[r['path']]=r['after_sha256']
drift=[k for k,h in expected.items() if not k.startswith('.atena/') and sha(root/k)!=h];assert not drift,drift
source_drift=[k for k,v in load(base/'b001/source-manifest.json').items() if sha(src/k)!=v['sha256']];assert not source_drift,source_drift
protected=['data/stages.json','data/chapter_flow.json','data/prototype_stages.json','data/level_design.json','data/stage_rules.json','data/stage_story.json','data/stage_structures.json','data/hqs.json','core/hq_catalog.gd','core/chapter_flow.gd','core/terrain_layout.gd','core/hero.gd','ui/hq_screen.gd','ui/hq_screen.tscn','ui/ground_decals.gd','project.godot','export_presets.cfg']
protected += [k for k in before if k.startswith(('assets/','ui/stages/'))]
assert all(sha(root/k)==before[k] for k in protected),[k for k in protected if sha(root/k)!=before[k]]
assert not (root/'assets/animations/enemies/totem_de_chefe/death.png').exists()
assert not (root/'ui/touch_ui.gd').exists() and not (root/'ui/mobile_controls.gd').exists()
assert 'return false' in (root/'core/game.gd').read_text(encoding='utf-8').split('func touch_controls_enabled()')[1].split('func ')[0]
suite=(val/'suite-final.log').read_text(encoding='utf-8');failures=re.findall(r'(?m)^FALHA .*',suite);baseline=next(r for r in load(base/'b001/baseline-pc/results.json')['results'] if r['name']=='suite')
assert set(failures)==set(baseline['failures']) and len(failures)==30
assert suite.count('SCRIPT ERROR:')==2 and 'Parse Error:' not in suite
assert 'test_fog_edge.gd:159' in suite and 'test_fog_edge.gd:161' in suite
assert load(val/'workspace-import.json')=={'exit_code':0,'script_errors':0,'engine_errors':0,'synthetic_user_dir_verified':True,'root_project_config_unchanged':True}
for name,n in [('native-results.json',37),('ui-native-results.json',13)]:
 r=load(val/name);assert r['exit_code']==0 and r['script_errors']==0 and not r['failures'] and any(str(n)+' checks; 0 failures' in x for x in r['summary'])
controller=(val/'controller.log').read_text(encoding='utf-8');assert '94 verificacoes; 0 falha(s)' in controller and 'SCRIPT ERROR:' not in controller
smoke=(val/'smoke-final.log').read_text(encoding='utf-8');assert 'smoke: ok' in smoke and 'SCRIPT ERROR:' not in smoke
report={'status':'B003_TECHNICAL_COMPLETE_WITH_INHERITED_DEBTS','written_paths':len(rows),'protected_paths':len(protected),'source_unchanged':True,'candidate_matches_delivery':True,'assets_maps_hqs_retained_unchanged':True,'pc_campaign_order_unchanged':True,'boss_combat_orders_independent_from_campaign':True,'new_functional_assertion_failures':0,'inherited_assertion_failures':30,'inherited_script_errors':2,'inherited_script_test':'test_fog_edge','suite_teardown_errors':len(re.findall(r'(?m)^ERROR:',suite)),'smoke_teardown_errors':len(re.findall(r'(?m)^ERROR:',smoke)),'smoke_maps':len(re.findall(r'(?m)^smoke \w+:',smoke)),'controller_checks':94,'native_runtime_checks':37,'native_ui_checks':13,'workspace_import':'PASS_ZERO_ERRORS','save_profile':'SYNTHETIC_ONLY','human_acceptance':False,'content_state':'DRAFT_RETAINED_GATES_UNCHANGED','canon_promotion':False,'export_commit_push':False}
(b/'verification-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8');(b/'final-write-set.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
matrix=load(base/'b002/functional-matrix-r2.json')
for r in matrix:
 if 'B003' in r.get('integration_status',''):r['integration_status']='B003_INTEGRATED_TECHNICAL_PASS_WITH_BASELINE_DEBTS';r['b003_evidence']='.atena/evidence/EVID-NOTTGARD-SOURCE-PORT-B003-20261018-r1.md'
(b/'functional-matrix-r3.json').write_text(json.dumps(matrix,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(report,ensure_ascii=False,indent=2))
