from pathlib import Path
import re,sys,difflib
sys.stdout.reconfigure(encoding='utf-8')
for folder in ['core','ui']:
 for p in Path(folder).glob('*.gd'):
  t=p.read_text(encoding='utf-8-sig');matches=list(re.finditer(r'(?m)^(?:static )?func (\w+)\(',t));by={}
  for i,m in enumerate(matches):by.setdefault(m.group(1),[]).append((m.start(),matches[i+1].start() if i+1<len(matches) else len(t)))
  for name,ranges in by.items():
   if len(ranges)<2:continue
   print(p,name,[t[:a].count('\n')+1 for a,z in ranges]);print('\n'.join(list(difflib.unified_diff(t[ranges[0][0]:ranges[0][1]].splitlines(),t[ranges[1][0]:ranges[1][1]].splitlines(),n=1))[:70]))
