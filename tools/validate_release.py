"""Run Godot checks with a probed synthetic user directory; never use the real profile."""
from pathlib import Path
import os,sys,json,re,subprocess,datetime,shutil

root=Path(__file__).resolve().parent.parent
def _find_godot():
    # NOTTGARD_GODOT tem prioridade; depois o executável 4.7.2 da própria pasta do projeto; por fim o caminho antigo.
    for candidate in [os.environ.get('NOTTGARD_GODOT'),str(root/'Godot_v4.7.2-stable_win64.exe'),'D:/Godot/godot.exe']:
        if candidate and Path(candidate).is_file(): return candidate
    raise SystemExit('Godot não encontrado: defina NOTTGARD_GODOT ou coloque Godot_v4.7.2-stable_win64.exe na raiz do projeto.')
GODOT=_find_godot()
PREFIX=['rtk','proxy'] if shutil.which('rtk') else []   # rtk é opcional (RTK.md)
session=root/'tmp'/('release-validation-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%d-%H%M%S'))
session.mkdir(parents=True)
env=os.environ.copy()
for key,folder in [('APPDATA','appdata'),('LOCALAPPDATA','localappdata')]:
    path=session/folder; path.mkdir(); env[key]=str(path)
profile=session/'synthetic-profile.json'; profile.write_text('{}',encoding='utf-8')
config=(root/'project.godot').read_text(encoding='utf-8')
custom=re.search(r'^config/custom_user_dir_name="([^"]+)"',config,re.M).group(1)
probe=session/'probe'; probe.mkdir()
(probe/'project.godot').write_text('config_version=5\n[application]\nconfig/name="ReleaseIsolationProbe"\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="'+custom+'"\n',encoding='utf-8')
(probe/'probe.gd').write_text('extends SceneTree\nfunc _init() -> void:\n print("ISOLATED_USER_DIR="+OS.get_user_data_dir())\n quit()\n',encoding='utf-8')
def invoke(name,args,timeout=180):
    startup=None
    if os.name=='nt' and name != 'human-preview':
        startup=subprocess.STARTUPINFO(); startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW; startup.wShowWindow=0
    proc=subprocess.run([*PREFIX,GODOT,*args],cwd=root,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,encoding='utf-8',errors='replace',timeout=timeout,startupinfo=startup)
    (session/(name+'.log')).write_text(proc.stdout,encoding='utf-8')
    return proc
check=invoke('probe',['--headless','--path',str(probe),'-s','probe.gd'])
found=re.search(r'ISOLATED_USER_DIR=([^\r\n]+)',check.stdout)
assert check.returncode==0 and found,check.stdout
userdir=Path(found.group(1).strip()).resolve()
assert userdir.is_relative_to(session.resolve()),str(userdir)
print('PASS: synthetic user directory verified',flush=True)
prep=invoke('import',['--headless','--editor','--import','--path',str(root),'--','--controller-profile',str(profile)],300)
assert prep.returncode==0 and not re.search(r'SCRIPT ERROR:|Parse Error:',prep.stdout),prep.stdout[-6000:]
print('PASS: Godot import',flush=True)
if '--playtest-integrated-hqs' in sys.argv:
    print('Synthetic review: HQ21 then HQ04. Advance: Enter/Space/click. Esc: next HQ/exit.',flush=True)
    proc=invoke('human-preview',['--path',str(root),'--resolution','1280x720','-s','tools/preview_integrated_hqs.gd','--','--controller-profile',str(profile)],43200)
    print('SESSION='+str(session),flush=True)
    sys.exit(proc.returncode)
if '--captures' in sys.argv or '--integrated-hq-captures' in sys.argv:
    integrated = '--integrated-hq-captures' in sys.argv
    capture_script = 'tools/capture_integrated_hqs.gd' if integrated else 'tools/capture_chapter2_hqs.gd'
    expected_captures = 26 if integrated else 12
    proc=invoke('captures',['--path',str(root),'--position','-10000,-10000','--resolution','1280x720','--quit-after','2400','-s',capture_script,'--','--controller-profile',str(profile),'--capture-dir',str(session)])
    passed=proc.returncode==0 and ('CAPTURES_PASS='+str(expected_captures)) in proc.stdout and re.search(r'ERROR:|SCRIPT ERROR:|CAPTURE_FAILED',proc.stdout) is None
    print(proc.stdout[-3000:],flush=True)
    (session/'capture-results.json').write_text(json.dumps(dict(passed=passed,user_data_dir=str(userdir),captures=[p.name for p in session.glob('*.png')]),indent=2),encoding='utf-8')
    print('SESSION='+str(session),flush=True)
    sys.exit(0 if passed else 1)
if '--full' in sys.argv:
    # Gates G1/G2 da release: suíte inteira (0 falhas e 0 SCRIPT ERROR) e auditoria do projeto (0 erros).
    suite=invoke('suite',['--headless','--path',str(root),'-s','tests/run_all.gd','--','--controller-profile',str(profile)],1800)
    suite_ok=suite.returncode==0 and re.search(r'testes: 0 falha\(s\)',suite.stdout) is not None and re.search(r'SCRIPT ERROR:|Parse Error:|FALHA ',suite.stdout) is None
    print('suite: '+('PASS' if suite_ok else 'FAIL'),flush=True)
    if not suite_ok: print(suite.stdout[-5000:],flush=True)
    audit=invoke('audit',['--headless','--path',str(root),'-s','tools/audit_projeto.gd'],600)
    audit_ok=re.search(r'RESUMO;erros=0;',audit.stdout) is not None
    print('audit_projeto: '+('PASS' if audit_ok else 'FAIL'),flush=True)
    if not audit_ok: print(audit.stdout[-3000:],flush=True)
    (session/'full-results.json').write_text(json.dumps(dict(session=str(session),user_data_dir=str(userdir),suite=suite_ok,audit=audit_ok),indent=2),encoding='utf-8')
    print('SESSION='+str(session),flush=True)
    sys.exit(0 if suite_ok and audit_ok else 1)
tests=sys.argv[1:] or ['test_chapter2_hqs','test_hqs','test_chapter_flow','test_profile','test_save_resilience','test_data','test_scripts_compile','test_platform_contract','test_map_objectives','test_terrain','test_root_navigation','test_root_art','test_domwieck_art','test_yggdrasil_map','test_yggdrasil_navigation','test_yggdrasil_art','test_dagruve_encounter','test_qa_sandbox','test_stage_story','test_stage_structures','test_version_contract','test_stage_deferrals','test_save_upgrade_050']
results=[]
for test in tests:
    proc=invoke(test,['--headless','--quit-after','2400','--path',str(root),'-s','tools/run_one_test.gd','--','--controller-profile',str(profile),test])
    passed=proc.returncode==0 and re.search(re.escape(test)+r': 0 falha',proc.stdout) is not None and re.search(r'SCRIPT ERROR:|Parse Error:|FALHA |ERROR:',proc.stdout) is None
    results.append(dict(test=test,passed=passed,exit_code=proc.returncode))
    print(test+': '+('PASS' if passed else 'FAIL'),flush=True)
    if not passed: print(proc.stdout[-5000:],flush=True)
(session/'results.json').write_text(json.dumps(dict(session=str(session),user_data_dir=str(userdir),profile=str(profile),results=results),indent=2),encoding='utf-8')
print('SESSION='+str(session),flush=True)
sys.exit(0 if all(row['passed'] for row in results) else 1)
