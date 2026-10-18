from pathlib import Path
import json
folder=max(Path('.atena/generated/chapter1-integration-20261017').glob('s004-validation-*'))
print(folder)
for path in folder.glob('legacy-diff-*.json'):
    value=json.loads(path.read_text(encoding='utf-8-sig'))
    before,after=value['before'],value['after']
    print(path.name, [(k,before.get(k),after.get(k)) for k in before.keys()|after.keys() if before.get(k)!=after.get(k)])
for name in ['reader.log','regression-reader.json']:
    path=folder/name
    if path.exists(): print(name,path.read_text(errors='replace')[-4000:])
