from pathlib import Path
import subprocess,json,collections,re,hashlib
r=Path.cwd(); base=r/'.atena/generated/hq-integration-20261017'
def git(*args):
    p=subprocess.run(['rtk','proxy','git',*args],cwd=r,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    assert p.returncode==0,p.stderr.decode(errors='replace')
    return p.stdout
tracked=git('diff','--name-only','-z').decode().split('\0')
others=git('ls-files','--others','--exclude-standard','-z').decode().split('\0')
selected=set(p for p in tracked if p)
excluded=[]
allowed_generated={'hq19-production-20261017','hq20-production-20261017','hq-integration-20261017','hq19-selection-20261017','hq20-reference-selection-20261017','yggdrasil-art-20261017','domwieck-art-20261017','root-art-20261017','chapter1-integration-20261017'}
accepted_images=set()
for num in [19,20]:
    m=json.loads((r/f'.atena/generated/hq{num}-production-20261017/approved-sequence-r1.json').read_text(encoding='utf-8'))
    accepted_images.update(row['candidate'] for row in m['panels'])
for path in others:
    if not path: continue
    p=Path(path)
    if path.startswith('.atena/'):
        if '/SPEC-DEV-' in path or '/EVID-DEV-' in path:
            excluded.append(path); continue
        if path.startswith('.atena/generated/'):
            parts=p.parts
            if p.name in ['payload-review-r1.json','stage-paths.txt','publication.json']:
                excluded.append(path); continue
            if len(parts)<4 or parts[2] not in allowed_generated:
                excluded.append(path); continue
            if any(part in ['appdata','localappdata','probe','captures','validation','web','pc','baseline','candidate'] or part.startswith(('validation-','s004-validation-','s005-validation-')) for part in parts[3:]):
                excluded.append(path); continue
            if p.suffix.lower() in ['.png','.jpg','.jpeg'] and path not in accepted_images:
                excluded.append(path); continue
            if p.suffix.lower() not in ['.json','.md','.txt','.py','.cjs','.ps1','.gd','.png','.jpg','.jpeg']:
                excluded.append(path); continue
            if 'before' in p.stem or 'baseline' in p.stem or 'hqs-before' in p.stem:
                excluded.append(path); continue
    if any(part in ['.git','.godot','tmp','build','evidencias'] for part in p.parts):
        excluded.append(path); continue
    selected.add(path)
entries=[]; findings=[]
for path in sorted(selected):
    file=r/path
    if not file.is_file(): continue
    size=file.stat().st_size
    if size>90*1024*1024: findings.append(dict(path=path,reason='over_90_MiB'))
    if re.search(r'(?i)(^|/)(\.env|id_rsa|id_ed25519|credentials|token)(\.|$)',path): findings.append(dict(path=path,reason='sensitive_filename'))
    if file.suffix.lower() in ['.json','.md','.txt','.py','.gd','.ps1','.cjs','.yaml','.yml','.toml','.cfg']:
        content=file.read_text(encoding='utf-8',errors='replace')
        if re.search(r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{30,}|sk-proj-[A-Za-z0-9_-]{30,}',content): findings.append(dict(path=path,reason='credential_pattern'))
    entries.append(dict(path=path,size=size,sha256=hashlib.sha256(file.read_bytes()).hexdigest()))
report=dict(selected=entries,excluded_count=len(excluded),excluded=excluded,findings=findings,total_bytes=sum(e['size'] for e in entries))
(base/'payload-review-r1.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
(base/'stage-paths.txt').write_text('\n'.join(e['path'] for e in entries)+'\n',encoding='utf-8')
print(json.dumps(dict(files=len(entries),MiB=round(report['total_bytes']/1024/1024,1),excluded=len(excluded),findings=findings,top=collections.Counter(e['path'].split('/')[0] for e in entries)),ensure_ascii=False))
assert not findings,'Review findings before staging'
