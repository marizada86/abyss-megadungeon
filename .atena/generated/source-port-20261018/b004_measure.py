from pathlib import Path
import json,hashlib,shutil,subprocess,os,re,sys,time
sys.stdout.reconfigure(encoding='utf-8');work=Path.cwd();base=work/'.atena/generated/source-port-20261018';out=base/'b004';session=work/'tmp/port-b4/user';session.mkdir(parents=True,exist_ok=True)
(session.parent/'.gdignore').write_text('',encoding='utf-8');env=os.environ.copy()
for var,d in [('APPDATA','a'),('LOCALAPPDATA','l')]:
 p=session/d;p.mkdir(exist_ok=True);env[var]=str(p)
profile=session/'profile.json';profile.write_text('{}',encoding='utf-8');startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
projects={'baseline':work/'tmp/port-b1/pc','candidate':work/'tmp/port-b3/candidate'}
old=json.loads((base/'b001/pc-manifest.json').read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for rel,e in old.items():
 if rel.startswith(('core/','ui/','data/')) and not rel.endswith('.uid'):assert sha(projects['baseline']/rel)==e['sha256'],'baseline drift '+rel
configs=[(p/'project.godot').read_text(encoding='utf-8')for p in projects.values()];names=[re.search(r'^config/custom_user_dir_name="([^"]+)"',c,re.M).group(1)for c in configs];assert names[0]==names[1]
probe=session/'probe';probe.mkdir(exist_ok=True);(probe/'project.godot').write_text('config_version=5\n[application]\nconfig/name="B004Isolation"\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="'+names[0]+'"\n',encoding='utf-8');(probe/'probe.gd').write_text('extends SceneTree\nfunc _init():\n print("ISOLATED_USER_DIR="+OS.get_user_data_dir())\n quit()\n',encoding='utf-8')
p=subprocess.run(['rtk','proxy','D:/Godot/godot.exe','--headless','--path',str(probe),'-s','probe.gd'],env=env,capture_output=True,timeout=40,startupinfo=startup);t=p.stdout.decode('utf-8',errors='replace');m=re.search('ISOLATED_USER_DIR=([^\r\n]+)',t);assert p.returncode==0 and m and Path(m.group(1).strip()).resolve().is_relative_to(session.resolve())
(out/'isolation.json').write_text(json.dumps({'verified':True,'user_dir':m.group(1).strip(),'real_save_access':False},indent=2),encoding='utf-8')
results=[]
for i,label in enumerate(['baseline','candidate','candidate','baseline'],1):
 root=projects[label];shutil.copyfile(out/'benchmark.gd',root/'tools/port_benchmark.gd');dest=out/(str(i)+'-'+label+'.json');log=out/(str(i)+'-'+label+'.log')
 with log.open('w',encoding='utf-8')as f:
  p=subprocess.run(['rtk','proxy','D:/Godot/godot.exe','--path',str(root),'--position','-10000,-10000','--resolution','1280x720','--fixed-fps','60','--quit-after','2000','-s','res://tools/port_benchmark.gd','--','--controller-profile',str(profile),'--benchmark-out',str(dest)],cwd=root,env=env,stdout=f,stderr=subprocess.STDOUT,timeout=120,startupinfo=startup)
 t=log.read_text(encoding='utf-8');assert p.returncode==0 and dest.exists() and 'SCRIPT ERROR:'not in t,(label,t[-2500:]);r=json.loads(dest.read_text(encoding='utf-8'));r['label']=label;r['sequence']=i;r['teardown_engine_errors']=len(re.findall(r'(?m)^ERROR:',t));results.append(r)
 (out/'measurement-results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8');print(label,i,'p95_ms',r['render_p95_ms'],'CPU_ms',r['cpu_total_ms'],flush=True)
summary={}
for label in projects:
 rs=[r for r in results if r['label']==label];summary[label]={k:round(sum(r[k]for r in rs)/len(rs),3)for k in ['render_median_ms','render_p95_ms','render_p99_ms','static_memory_bytes','cpu_total_ms','cpu_enemies']}
aa=summary['baseline']['render_p95_ms'];zz=summary['candidate']['render_p95_ms'];summary['render_investigation_signal']=zz>aa*1.25 and zz-aa>2;summary['candidate_p95_within_indicative_60fps']=zz<=1000/60;summary['human_acceptance']=False;summary['acceptance_threshold']='DIAGNOSTIC_PROPOSAL_NOT_CANON';(out/'measurement-summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(summary,ensure_ascii=False,indent=2))
