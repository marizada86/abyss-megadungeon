from pathlib import Path
import sys,os,json,subprocess,re,time
sys.stdout.reconfigure(encoding='utf-8')
label=sys.argv[1];work=Path.cwd();root=work/'tmp/port-b1'/label
out=work/'.atena/generated/source-port-20261018/b001'/('baseline-'+label)
session=work/'tmp/port-b1'/('user-'+label)
isolation=json.loads((out/'isolation.json').read_text());assert isolation['verified']
env=os.environ.copy();env['APPDATA']=str(session/'a');env['LOCALAPPDATA']=str(session/'l')
profile=session/'followup-profile.json';profile.write_text('{}',encoding='utf-8')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
checks=[('warm-import',['--editor','--import'])]
if label=='source' and '--mobile' in sys.argv:
 (root/'.atena/generated/mobile-controls/v02').mkdir(parents=True,exist_ok=True)
 checks.append(('mobile-retry',['--quit-after','2400','res://tools/mobile_buttons_check.tscn']))
if label=='pc':
 checks += [(name,['--quit-after','2400','-s','tools/run_one_test.gd']) for name in ['test_affixes','test_fog_edge','test_audio','test_chronicles','test_game_design','test_ground_decals','test_playtest','test_random_events']]
results=[]
for name,args in checks:
 command=['rtk','proxy','D:/Godot/godot.exe','--headless','--path',str(root),*args,'--','--controller-profile',str(profile)]
 if name.startswith('test_'):command.append(name)
 p=subprocess.run(command,cwd=root,env=env,capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=150,startupinfo=startup)
 text=p.stdout+p.stderr;(out/(name+'.log')).write_text(text,encoding='utf-8')
 row={'name':name,'exit_code':p.returncode,'script_errors':len(re.findall('SCRIPT ERROR:',text)),'engine_errors':len(re.findall(r'(?m)^ERROR:',text)),'failures':re.findall(r'(?m)^FALHA .*',text),'summaries':re.findall(r'(?m)^.*falha\(s\).*$',text)}
 results.append(row);(out/'followup-results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
 print(label,json.dumps(row,ensure_ascii=False),flush=True)
