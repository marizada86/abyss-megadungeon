from pathlib import Path
import sys,subprocess,json,os
sys.stdout.reconfigure(encoding='utf-8')
src=Path('D:/dev/nottgard/games/godot/nottgard-survivors'); dst=Path.cwd()
for root in [src,dst]:
 print('\nPROJECT',root)
 for args in [('rev-parse','--is-bare-repository'),('config','--get','core.worktree'),('config','--get','core.bare'),('rev-parse','--absolute-git-dir')]:
  p=subprocess.run(['rtk','proxy','git','-C',str(root),*args],capture_output=True,text=True,encoding='utf-8',errors='replace');print(args,p.returncode,p.stdout.strip(),p.stderr.strip()[:300])
 for f in ['tests/run_all.gd','tools/smoke.gd','tools/controller_check.gd','tools/mobile_buttons_check.gd','tools/run_one_test.gd','tools/validate_release.py']:
  p=root/f
  if p.exists(): print('\nFILE',f,'\n',p.read_text(encoding='utf-8-sig')[:18000])
print('GAME GUIDE\n'+Path('C:/Users/gui-m/.codex/atena-guidance/games-and-visuals.md').read_text(encoding='utf-8-sig'))
