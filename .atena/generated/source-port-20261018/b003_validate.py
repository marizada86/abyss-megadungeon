from pathlib import Path
import os,sys,json,re,subprocess,time
sys.stdout.reconfigure(encoding='utf-8')
work=Path.cwd();root=work/'tmp/port-b3/candidate';out=work/'.atena/generated/source-port-20261018/b003/validation';out.mkdir(parents=True,exist_ok=True)
session=work/'tmp/port-b3/user';session.mkdir(exist_ok=True);env=os.environ.copy()
for var,name in [('APPDATA','a'),('LOCALAPPDATA','l')]:
 p=session/name;p.mkdir(exist_ok=True);env[var]=str(p)
profile=session/'profile.json';profile.write_text('{}',encoding='utf-8')
probe=session/'probe';probe.mkdir(exist_ok=True)
config=(root/'project.godot').read_text(encoding='utf-8');custom=re.search(r'^config/custom_user_dir_name="([^"]+)"',config,re.M).group(1)
(probe/'project.godot').write_text('config_version=5\n[application]\nconfig/name="PortB003Isolation"\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="'+custom+'"\n',encoding='utf-8')
(probe/'probe.gd').write_text('extends SceneTree\nfunc _init() -> void:\n print("ISOLATED_USER_DIR="+OS.get_user_data_dir())\n quit()\n',encoding='utf-8')
results=[];startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
def invoke(name,args,seconds=240):
 path=out/(name+'.log');start=time.monotonic()
 with path.open('w',encoding='utf-8') as log:
  p=subprocess.Popen(['rtk','proxy','D:/Godot/godot.exe',*args],cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,startupinfo=startup)
  try:code=p.wait(timeout=seconds)
  except subprocess.TimeoutExpired:
   subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=15)
   code=-1
 text=path.read_text(encoding='utf-8',errors='replace');row={'name':name,'exit_code':code,'seconds':round(time.monotonic()-start,2),'script_errors':len(re.findall(r'SCRIPT ERROR:',text)),'parse_errors':len(re.findall('Parse Error:',text)),'engine_errors':len(re.findall(r'(?m)^ERROR:',text)),'failures':re.findall(r'(?m)^FALHA .*',text),'summary':re.findall(r'(?m)^.*(?:falha\(s\)|smoke:.*|integration:.*|PORT_VISUALS:.*).*$',text)[-12:]}
 results.append(row);(out/'results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(row,ensure_ascii=False),flush=True);return text,row
if '--targeted' in sys.argv:
 isolation=json.loads((out/'isolation.json').read_text());assert isolation['verified']
 checks=sys.argv[sys.argv.index('--targeted')+1:]
 for name in checks:invoke(name,['--headless','--path',str(root),'--quit-after','2400','-s','tools/run_one_test.gd','--','--controller-profile',str(profile),name],180)
 sys.exit(0)
text,row=invoke('probe',['--headless','--path',str(probe),'-s','probe.gd'],40)
m=re.search(r'ISOLATED_USER_DIR=([^\r\n]+)',text);assert m and row['exit_code']==0
assert Path(m.group(1).strip()).resolve().is_relative_to(session.resolve())
(out/'isolation.json').write_text(json.dumps({'verified':True,'user_data_dir':m.group(1).strip(),'real_save_access':False,'profile':str(profile)},indent=2),encoding='utf-8')
common=['--headless','--path',str(root)]
text,row=invoke('import',common+['--editor','--import','--','--controller-profile',str(profile)],360)
if row['parse_errors'] or row['script_errors']:
 print('IMPORT_REQUIRES_DIAGNOSIS',flush=True);sys.exit(1)
invoke('suite',common+['--quit-after','36000','-s','tests/run_all.gd','--','--controller-profile',str(profile)],300)
invoke('smoke',common+['--quit-after','12000','res://tools/smoke.tscn','--','--controller-profile',str(profile)],180)
invoke('controller',common+['--quit-after','36000','res://tools/controller_check.tscn','--','--controller-profile',str(profile)],240)
print('B003_VALIDATION_FINISHED',flush=True)

