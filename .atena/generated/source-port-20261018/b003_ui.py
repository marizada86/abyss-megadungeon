from pathlib import Path
import os,sys,json,subprocess,re,shutil
sys.stdout.reconfigure(encoding='utf-8')
work=Path.cwd();base=work/'.atena/generated/source-port-20261018/b003';out=base/'validation';root=work/'tmp/port-b3/candidate';session=work/'tmp/port-b3/user'
assert json.loads((out/'isolation.json').read_text())['verified']
env=os.environ.copy();env['APPDATA']=str(session/'a');env['LOCALAPPDATA']=str(session/'l')
profile=session/'visual-profile.json';profile.write_text('{}',encoding='utf-8')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
shutil.copyfile(base/'ui_probe.gd',root/'tools/port_ui_probe.gd')
with (out/'ui-native.log').open('w',encoding='utf-8') as log:
 p=subprocess.Popen(['rtk','proxy','D:/Godot/godot.exe','--path',str(root),'--position','-10000,-10000','--resolution','1280x720','--quit-after','2400','-s','res://tools/port_ui_probe.gd','--','--controller-profile',str(profile),'--port-out',str(out)],cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,startupinfo=startup)
 try:code=p.wait(timeout=100)
 except subprocess.TimeoutExpired:
  subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=15);code=-1
text=(out/'ui-native.log').read_text(encoding='utf-8',errors='replace')
report={'exit_code':code,'script_errors':len(re.findall('SCRIPT ERROR:',text)),'parse_errors':len(re.findall('Parse Error:',text)),'failures':re.findall(r'(?m)^PORT_VISUAL_FAILED:.*',text),'summary':re.findall(r'(?m)^PORT_VISUALS:.*',text),'screenshots':[p.name for p in out.glob('options-*.png')],'human_acceptance':False}
(out/'ui-native-results.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps(report,ensure_ascii=False,indent=2))


