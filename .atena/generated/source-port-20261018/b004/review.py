from pathlib import Path
import os,sys,subprocess,json,hashlib,shutil,re,datetime
sys.stdout.reconfigure(encoding='utf-8')
base=Path(__file__).resolve().parent;workspace=base.parents[3];candidate=workspace/'tmp/port-b3/candidate';verify='--verify-launch'in sys.argv
seal=json.loads((base/'review-seal.json').read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None
print('Conferindo a versão preparada para avaliação...',flush=True)
for r in seal['files']:
 if sha(candidate/r['path'])!=r['sha256']:raise RuntimeError('A versão preparada mudou: '+r['path'])
assert sha(base/'review-entry.gd')==seal['entry_sha256'],'O iniciador mudou desde a verificação.'
shutil.copyfile(base/'review-entry.gd',candidate/'tools/port_human_review.gd')
session=base/'sessions'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%d-%H%M%S-%f');session.mkdir(parents=True);env=os.environ.copy()
for var,d in [('APPDATA','appdata'),('LOCALAPPDATA','localappdata')]:
 p=session/d;p.mkdir();env[var]=str(p)
profile=session/'profile-sintetico.json';profile.write_text('{}',encoding='utf-8');probe=session/'probe';probe.mkdir()
config=(candidate/'project.godot').read_text(encoding='utf-8');name=re.search(r'^config/custom_user_dir_name="([^"]+)"',config,re.M).group(1);assert 'config/use_custom_user_dir=true'in config
(probe/'project.godot').write_text('config_version=5\n[application]\nconfig/name="PortReviewProbe"\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="'+name+'"\n',encoding='utf-8')
(probe/'probe.gd').write_text('extends SceneTree\nfunc _init():\n print("ISOLATED_USER_DIR="+OS.get_user_data_dir())\n quit()\n',encoding='utf-8')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
p=subprocess.run(['D:/Godot/godot.exe','--headless','--path',str(probe),'-s','probe.gd'],env=env,capture_output=True,timeout=40,startupinfo=startup)
t=p.stdout.decode('utf-8',errors='replace');m=re.search('ISOLATED_USER_DIR=([^\r\n]+)',t);assert p.returncode==0 and m and Path(m.group(1).strip()).resolve().is_relative_to(session),'Isolamento não confirmado; jogo não iniciado.'
(session/'isolation.json').write_text(json.dumps({'verified':True,'user_dir':m.group(1).strip(),'real_save_access':False,'runtime_fingerprint':seal['fingerprint']},indent=2),encoding='utf-8')
args=['D:/Godot/godot.exe','--path',str(candidate),'--resolution','1280x720','--log-file',str(session/'engine.log'),'-s','res://tools/port_human_review.gd','--','--controller-profile',str(profile),'--review-session',str(session)]
if verify:args[1:1]=['--position','-10000,-10000','--quit-after','1200'];args.append('--verify-review')
print('Abrindo avaliação com dados de teste separados...',flush=True)
with (session/'review.log').open('w',encoding='utf-8')as log:
 p=subprocess.run(args,cwd=candidate,env=env,stdout=log,stderr=subprocess.STDOUT,startupinfo=startup if verify else None,timeout=100 if verify else None)
assert p.returncode==0,'Falha ao abrir avaliação. Registros: '+str(session)
if verify:
 report=json.loads((session/'launch-verification.json').read_text(encoding='utf-8'));t=(session/'review.log').read_text(encoding='utf-8');assert not report['failures']and 'SCRIPT ERROR:'not in t and 'Parse Error:'not in t,(report,t[-2000:]);(base/'launcher-verification.json').write_text(json.dumps({'session':str(session),'verified':True,'failures':report['failures'],'human_acceptance':False,'teardown_engine_errors':len(re.findall(r'(?m)^ERROR:',t))},indent=2),encoding='utf-8');print('PASS REVIEW SESSION='+str(session))
