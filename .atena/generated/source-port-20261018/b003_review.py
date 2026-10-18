from pathlib import Path
import re,sys,json,difflib
sys.stdout.reconfigure(encoding='utf-8')
out=Path('.atena/generated/source-port-20261018/b003')
for name in sys.argv[1:]:
 p=out/'merged'/name;t=p.read_text(encoding='utf-8-sig');print('\nFILE',name)
 for i,m in enumerate(re.finditer(r'(?ms)^<<<<<<<.*?^>>>>>>>[^\n]*\n',t)):
  line=t[:m.start()].count('\n')+1
  print('CONFLICT',i+1,'line',line,'\n',m.group(0))
