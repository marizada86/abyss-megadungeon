from pathlib import Path
import json,hashlib,collections,subprocess,sys
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();base=root/'.atena/generated/source-port-20261018';out=base/'b004';src=Path('D:/dev/nottgard/games/godot/nottgard-survivors');load=lambda p:json.loads(p.read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None
old=load(base/'b001/pc-manifest.json');source=load(base/'b001/source-manifest.json');expected={k:v['sha256']for k,v in old.items()};writes={}
for batch in ['b002','b003']:
 for r in load(base/batch/'final-write-set.json'):expected[r['path']]=r['after_sha256'];writes[r['path']]=r
drift=[k for k,h in expected.items() if not k.startswith('.atena/') and sha(root/k)!=h];assert not drift,drift
drift=[k for k,v in source.items() if sha(src/k)!=v['sha256']];assert not drift,drift
candidate=root/'tmp/port-b3/candidate';seal=[]
for k,h in expected.items():
 if k.startswith(('core/','data/','ui/','assets/')) or k in ['project.godot','icon.svg','export_presets.cfg']:
  if k.endswith('.import'):continue
  assert sha(candidate/k)==h,'candidate drift '+k
  seal.append({'path':k,'sha256':h})
seal.sort(key=lambda x:x['path']);fingerprint=hashlib.sha256(json.dumps(seal,sort_keys=True).encode()).hexdigest()
(out/'review-seal.json').write_text(json.dumps({'id':'PORT-PC-20261018-B004-r1','fingerprint':fingerprint,'files':seal,'entry_sha256':sha(out/'review-entry.gd'),'state':'DRAFT','human_acceptance':False},ensure_ascii=False,indent=2),encoding='utf-8')
remaining={r['path']for r in load(out/'remaining-dispositions.json')};history=[]
for rel in sorted(remaining):
 p=subprocess.run(['rtk','proxy','git','--git-dir='+str(src/'.git'),'show','b83f188a6dae9d32f78420a318bffedcac4ff4a3:'+rel],capture_output=True,timeout=30)
 unchanged=p.returncode==0 and p.stdout.decode('utf-8-sig').replace('\r\n','\n')==(src/rel).read_text(encoding='utf-8-sig')
 history.append({'path':rel,'source_has_no_change_since_split':unchanged,'resolution':'PRESERVE_PC_HQ_COMPOSITION_NO_DECORATION' if rel=='ui/hq_screen.gd' else 'PRESERVE_PC_VARIANT_PER_CONTRACT'})
(out/'preserved-conflicts.json').write_text(json.dumps(history,ensure_ascii=False,indent=2),encoding='utf-8')
matrix=load(base/'b001/disposition-matrix.json')
for r in matrix:
 rel=r['path'];r['delivered_sha256']=sha(root/rel)
 if rel in writes:r['final_status']='COPIED_SOURCE'if r['delivered_sha256']==source.get(rel,{}).get('sha256')else'SEMANTICALLY_INTEGRATED_PC';r['resolution']='B002/B003 verified write receipts; preserve DRAFT and independent content gates'
 elif r['disposition']=='EXCLUDE_MOBILE_TARGET':r['final_status']='EXCLUDED_MOBILE';r['resolution']='Windows x86_64 contract; no touch/web runtime admitted'
 elif r['disposition']=='REVIEW_DEV_TOOL_NO_AUTORUN':r['final_status']='CATALOGUED_DEV_SUPPORT_NO_ADMISSION';r['resolution']='Source path/hash retained in catalog; developer support is outside runtime parity; existing PC tool retained when present; no bulk execution'
 elif rel in remaining:r['final_status']='PRESERVED_PC_REVIEWED';r['resolution']='Historical comparison and integration contract; see preserved-conflicts.json'
 elif r['disposition']=='TEST_CONTRACT_INPUT_NON_RUNTIME':r['final_status']='RETAINED_TEST_INPUT';r['resolution']='Existing local test manifest; no personal history copied'
 elif r['comparison']=='identical':r['final_status']='REUSED_IDENTICAL';r['resolution']='Existing bytes reused'
 else:r['final_status']='PRESERVED_PC_OR_APPROVED_HQ';r['resolution']='Local contract, platform configuration or approved PC content preserved; retained resources not admitted'
 assert r['final_status']and r['resolution']
(out/'disposition-matrix-final.json').write_text(json.dumps(matrix,ensure_ascii=False,indent=2),encoding='utf-8')
report={'id':'PORT-PC-20261018-B004-r1','runtime_fingerprint':fingerprint,'runtime_sealed_paths':len(seal),'matrix_total_paths':len(matrix),'final_dispositions':dict(collections.Counter(r['final_status']for r in matrix)),'unresolved_file_dispositions':0,'source_original_unchanged':True,'delivered_runtime_unchanged_since_b003':True,'candidate_matches_delivery':True,'reused_validation':'B001 source + B003 suite-final, smoke-final, import, controller and native probes; unchanged input hashes','human_acceptance':False,'draft_and_retention_gates':'UNCHANGED','export_publication':'NOT_PERFORMED'}
(out/'integrity-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(report,ensure_ascii=False,indent=2))
