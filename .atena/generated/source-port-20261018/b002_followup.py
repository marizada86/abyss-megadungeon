from pathlib import Path
import shutil,subprocess,os,json,re,sys
sys.stdout.reconfigure(encoding='utf-8')
work=Path.cwd();root=work/'tmp/port-b2/candidate';base=work/'.atena/generated/source-port-20261018/b002';out=base/'validation';session=work/'tmp/port-b2/user'
shutil.copyfile(work/'tests/test_radiant_pulse_vfx.gd',root/'tests/test_radiant_pulse_vfx.gd')
assert json.loads((out/'isolation.json').read_text())['verified']
env=os.environ.copy();env['APPDATA']=str(session/'a');env['LOCALAPPDATA']=str(session/'l')
profile=session/'followup-profile.json';profile.write_text('{}',encoding='utf-8')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
tests=['test_radiant_pulse_vfx','test_projectile_and_ability_vfx','test_actor_strips_b003','test_interaction_anim','test_breakable_death_art','test_happening_art','test_hero_own_art','test_walk_lab','test_hourglass_vfx','test_hero_portraits','test_scripts_compile','test_chapter2_hqs','test_hqs','test_chapter_flow','test_yggdrasil_navigation','test_root_navigation','test_dagruve_encounter','test_platform_contract']
results=[]
for name in tests:
 with (out/(name+'.log')).open('w',encoding='utf-8') as log:
  p=subprocess.run(['rtk','proxy','D:/Godot/godot.exe','--headless','--path',str(root),'--quit-after','2400','-s','tools/run_one_test.gd','--','--controller-profile',str(profile),name],cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=150,startupinfo=startup)
 t=(out/(name+'.log')).read_text(encoding='utf-8',errors='replace');r={'test':name,'exit_code':p.returncode,'script_errors':len(re.findall('SCRIPT ERROR:|Parse Error:',t)),'failures':re.findall(r'(?m)^FALHA .*',t),'zero_failures':name+': 0 falha' in t,'engine_errors':re.findall(r'(?m)^ERROR:.*',t)}
 results.append(r);(out/'targeted-results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8');print(name,'PASS' if r['exit_code']==0 and r['script_errors']==0 and r['zero_failures'] else 'FAIL',flush=True)
assert all(r['exit_code']==0 and r['script_errors']==0 and r['zero_failures'] for r in results)
