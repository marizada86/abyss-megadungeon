from pathlib import Path
import re,json,hashlib,shutil
p=Path('ui/run.gd');t=p.read_text(encoding='utf-8');matches=list(re.finditer(r'(?m)^(?:static )?func (\w+)\(',t));seen=set();remove=[]
for i,m in enumerate(matches):
 name=m.group(1)
 if name in seen:remove.append((m.start(),matches[i+1].start() if i+1<len(matches) else len(t)))
 seen.add(name)
assert len(remove)==5
for a,z in reversed(remove):t=t[:a]+t[z:]
p.write_text(t,encoding='utf-8');shutil.copyfile(p,Path('tmp/port-b3/candidate')/p)
b=Path('.atena/generated/source-port-20261018/b003');rows=json.loads((b/'write-set-r1.json').read_text(encoding='utf-8'))
for r in rows:
 if r['path']==p.as_posix():r['after_sha256']=hashlib.sha256(p.read_bytes()).hexdigest()
(b/'write-set-r1.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8');print('Removed 5 identical helper duplicates from B002/source merge')
