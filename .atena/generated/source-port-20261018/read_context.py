from pathlib import Path
import sys
sys.stdout.reconfigure(encoding='utf-8')
src=Path('D:/dev/nottgard/games/godot/nottgard-survivors')
for pattern in ['.atena/specs/*176*','.atena/specs/*185*','.atena/evidence/*274*','.atena/evidence/*275*','.atena/evidence/*272*']:
 for p in src.glob(pattern):
  print('\nFILE',p)
  if p.is_file(): print(p.read_text(encoding='utf-8-sig')[:14000])
for root in [src,Path.cwd()]:
 print('\nROOT',root)
 for f in ['project.godot','README.md']:
  print(f,(root/f).read_text(encoding='utf-8-sig')[:7000])
 print('TESTS', [p.name for p in (root/'tests').glob('*.gd')])
