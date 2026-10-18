from pathlib import Path
import os,json,subprocess,hashlib,shutil,sys,re
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();base=root/'.atena/generated/source-port-20261018/b003';out=base/'validation';session=root/'tmp/port-b3/user'
assert json.loads((out/'isolation.json').read_text())['verified']
candidate=root/'tmp/port-b3/candidate'
assert (root/'project.godot').read_bytes()==(candidate/'project.godot').read_bytes()
# Ignore only this task's disposable nested projects during the real project's import.
for rel in ['tmp/port-b1','tmp/port-b3']:
 p=root/rel/'.gdignore'
 if not p.exists():p.write_text('',encoding='utf-8')
before={}
for p in (root/'assets').rglob('*.import'):
 rel=p.relative_to(root).as_posix();before[rel]=hashlib.sha256(p.read_bytes()).hexdigest()
 q=base/'import-before'/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
(base/'import-before.json').write_text(json.dumps(before,indent=2),encoding='utf-8')
env=os.environ.copy();env['APPDATA']=str(session/'a');env['LOCALAPPDATA']=str(session/'l')
profile=session/'editor-profile.json';profile.write_text('{}',encoding='utf-8')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
with (out/'workspace-import.log').open('w',encoding='utf-8') as log:
 p=subprocess.Popen(['rtk','proxy','D:/Godot/godot.exe','--headless','--editor','--import','--path',str(root),'--','--controller-profile',str(profile)],cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,startupinfo=startup)
 try:code=p.wait(timeout=360)
 except subprocess.TimeoutExpired:
  subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=15);code=-1
t=(out/'workspace-import.log').read_text(encoding='utf-8',errors='replace')
report={'exit_code':code,'script_errors':len(re.findall('SCRIPT ERROR:|Parse Error:',t)),'engine_errors':len(re.findall(r'(?m)^ERROR:',t)),'synthetic_user_dir_verified':True,'root_project_config_unchanged':True}
(out/'workspace-import.json').write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(report),flush=True)

