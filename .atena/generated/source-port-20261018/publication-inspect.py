from pathlib import Path
import subprocess,json,collections,sys
sys.stdout.reconfigure(encoding='utf-8');root=Path.cwd();out=root/'.atena/generated/source-port-20261018/publication';out.mkdir(exist_ok=True)
def git(*args):
 p=subprocess.run(['git',*args],capture_output=True,check=True);return p.stdout
assert not git('diff','--cached','--name-only').strip(),'Existing staged changes require preservation'
untracked=git('ls-files','--others','--exclude-standard','-z').decode('utf-8').split('\0');untracked=[p for p in untracked if p]
modified=git('diff','--name-only','-z').decode('utf-8').split('\0');modified=[p for p in modified if p]
(out/'working-tree-inventory.json').write_text(json.dumps({'untracked':untracked,'modified':modified},ensure_ascii=False,indent=2),encoding='utf-8')
print('UNTRACKED',len(untracked));print('BY_ROOT',dict(collections.Counter(p.split('/')[0]for p in untracked)))
print('UNTRACKED_NON_ADD',json.dumps([p for p in untracked if not p.startswith('.atena/')],ensure_ascii=False));print('ADD_TOP',dict(collections.Counter('/'.join(p.split('/')[:3])for p in untracked if p.startswith('.atena/'))))
print('LARGE',[(p,(root/p).stat().st_size)for p in untracked+modified if (root/p).is_file()and(root/p).stat().st_size>90*1024*1024])
