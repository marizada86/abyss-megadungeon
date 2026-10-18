from pathlib import Path
import shutil,json,sys
sys.stdout.reconfigure(encoding='utf-8')
root=Path.cwd();candidate=root/'tmp/port-b2/candidate';candidate.mkdir(parents=True,exist_ok=True)
for folder in ['assets','core','data','ui','tests','tools']:
 shutil.copytree(root/folder,candidate/folder,dirs_exist_ok=True,copy_function=shutil.copy2)
for name in ['project.godot','export_presets.cfg','icon.svg','icon.svg.import']:shutil.copy2(root/name,candidate/name)
cached=root/'tmp/port-b1/pc/.godot/imported'
if cached.exists():shutil.copytree(cached,candidate/'.godot/imported',dirs_exist_ok=True,copy_function=shutil.copy2)
for rel in json.loads((root/'.atena/generated/source-port-20261018/b001/pc-snapshot-scope.json').read_text(encoding='utf-8'))['retained_add_inputs']:
 p=candidate/rel;p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,p)
(candidate/'.atena/generated/controller-experience/v01').mkdir(parents=True,exist_ok=True)
(candidate/'.atena/generated/controller-experience/v02').mkdir(parents=True,exist_ok=True)
print('CANDIDATE',candidate,'runtime copied; imported cache reused; synthetic fixture directories ready',flush=True)
