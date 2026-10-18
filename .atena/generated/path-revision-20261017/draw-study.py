import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
base=Path(__file__).parent
data=json.loads((base/'geometry-contract-r1.json').read_text(encoding='utf-8'))
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',21)
small=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',16)
im=Image.new('RGB',(1500,850),'#10131c');p=ImageDraw.Draw(im)
for col,(key,title) in enumerate([('yggdrasil','Yggdrasil — malha-base; variação por semente'),('abyss','Primeira incursão — espiral com seis conexões')]):
 d=data[key];ox=35+col*750;oy=95;scale=11
 def xy(n):return (ox+n[0]*scale,oy+n[1]*scale)
 p.text((ox,20),title,font=font,fill='white')
 p.text((ox,52),'DRAFT r1 · desenho técnico 60 × 60 · sem arte final',font=small,fill='#b8c0ce')
 for k in range(0,61,10):
  p.line((ox+k*scale,oy,ox+k*scale,oy+660),fill='#252c3b')
  p.line((ox,oy+k*scale,ox+660,oy+k*scale),fill='#252c3b')
 for i,(a,b,w) in enumerate(d['edges']):
  pa,pb=xy(d['nodes'][a]),xy(d['nodes'][b]);color='#8e7254' if (i>=3 if key=='yggdrasil' else i>=17) else '#c9a06c'
  p.line((*pa,*pb),fill=color,width=round(w*scale))
  for x,y in [pa,pb]:p.ellipse((x-w*scale/2,y-w*scale/2,x+w*scale/2,y+w*scale/2),fill=color)
 for name,n in d['nodes'].items():
  x,y=xy(n);r=n[2]*scale;p.ellipse((x-r,y-r,x+r,y+r),fill='#a48761');p.text((x,y),name,font=small,fill='#10131c',anchor='mm')
 for name,color in [('arrival','#65e6b2'),('target','#cd9fff')]:
  x,y=xy(d[name]);r=22;p.ellipse((x-r,y-r,x+r,y+r),outline=color,width=4)
 p.text((ox,780),f"{len(d['nodes'])} junções · {len(d['edges'])} ligações na malha-base",font=small,fill='white')
p.text((35,820),'Verde: chegada · Roxo: destino · Escuro: vazio com bordas travadas. A espiral terá leitura visual de subida/descida.',font=small,fill='#ccd1dd')
im.save(base/'drawings-r1.png')
