from pathlib import Path
import os,sys,json,re,subprocess,time
sys.stdout.reconfigure(encoding='utf-8')
label=sys.argv[1];workspace=Path.cwd(); root=workspace/'tmp/port-b1'/label
out=workspace/'.atena/generated/source-port-20261018/b001'/('baseline-'+label);out.mkdir(exist_ok=True)
session=workspace/'tmp/port-b1'/('user-'+label);session.mkdir(exist_ok=True)
env=os.environ.copy()
for var,name in [('APPDATA','a'),('LOCALAPPDATA','l')]:
 folder=session/name;folder.mkdir(exist_ok=True);env[var]=str(folder)
profile=session/'synthetic-profile.json';profile.write_text('{}',encoding='utf-8')
config=(root/'project.godot').read_text(encoding='utf-8')
custom=re.search(r'^config/custom_user_dir_name="([^"]+)"',config,re.M).group(1)
probe=session/'probe';probe.mkdir(exist_ok=True)
(probe/'project.godot').write_text('config_version=5\n[application]\nconfig/name="PortBaselineProbe"\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="'+custom+'"\n',encoding='utf-8')
(probe/'probe.gd').write_text('extends SceneTree\nfunc _init() -> void:\n print("ISOLATED_USER_DIR="+OS.get_user_data_dir())\n quit()\n',encoding='utf-8')
results=[]
def invoke(name,args,timeout=300):
 started=time.monotonic()
 startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
 try:
  p=subprocess.run(['rtk','proxy','D:/Godot/godot.exe',*args],cwd=root,env=env,capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=timeout,startupinfo=startup)
  output=p.stdout+p.stderr;code=p.returncode
 except subprocess.TimeoutExpired as e:
  output=(e.stdout or b'').decode('utf-8',errors='replace') if isinstance(e.stdout,bytes) else (e.stdout or '')
  output+='\nHARNESS_TIMEOUT';code=-1
 (out/(name+'.log')).write_text(output,encoding='utf-8')
 row={'name':name,'exit_code':code,'seconds':round(time.monotonic()-started,2),'script_errors':len(re.findall(r'SCRIPT ERROR:|Parse Error:',output)),'engine_errors':len(re.findall(r'(?m)^ERROR:',output)),'failures':re.findall(r'(?m)^FALHA .*',output),'summary':re.findall(r'(?m)^.*(?:falha\(s\)|smoke.*|integration:.*|HARNESS_TIMEOUT).*$',output)[-20:]}
 results.append(row);(out/'results.json').write_text(json.dumps({'label':label,'snapshot':str(root),'session':str(session),'results':results},indent=2,ensure_ascii=False),encoding='utf-8')
 print(label,name,json.dumps(row,ensure_ascii=False),flush=True)
 return code,output
code,output=invoke('probe',['--headless','--path',str(probe),'-s','probe.gd'],45)
m=re.search(r'ISOLATED_USER_DIR=([^\r\n]+)',output)
assert code==0 and m,output
userdir=Path(m.group(1).strip()).resolve(); assert userdir.is_relative_to(session.resolve()),str(userdir)
(out/'isolation.json').write_text(json.dumps({'verified':True,'user_data_dir':str(userdir),'real_save_loaded':False,'profile':str(profile)},indent=2),encoding='utf-8')
common=['--headless','--path',str(root)]
invoke('import',common+['--editor','--import','--','--controller-profile',str(profile)],360)
invoke('suite',common+['-s','tests/run_all.gd','--','--controller-profile',str(profile)],360)
invoke('smoke',common+['res://tools/smoke.tscn','--','--controller-profile',str(profile)],180)
controller=root/'.atena/generated/controller-experience/v02';controller.mkdir(parents=True,exist_ok=True)
invoke('controller',common+['res://tools/controller_check.tscn','--','--controller-profile',str(profile)],280)
if label=='source':
 # Source's own platform contract includes mobile input; PC intentionally excludes it.
 for p in (root/'tools/mobile_buttons_check.gd').read_text(encoding='utf-8').splitlines():
  pass
 (root/'.atena/generated/mobile-controls/v02').mkdir(parents=True,exist_ok=True)
 invoke('mobile',common+['--quit-after','2400','res://tools/mobile_buttons_check.tscn','--','--controller-profile',str(profile)],220)
print('FINISHED',label,flush=True)
