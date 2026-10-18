from pathlib import Path
from PIL import Image,ImageOps,ImageDraw,ImageFont
import json,hashlib,math
r=Path.cwd(); v=Path('D:/dev/nottgard/vault'); out=r/'.atena/generated/hq19-selection-20261017'
refs=[('Aila S14 sem asas',v/'output/referencias-personagens/CHAR-002/S14-desperta/r01/aila-front-candidate-v02.png'),('Aila costas',v/'output/referencias-personagens/CHAR-002/S14-desperta/r01/aila-back-v01.png'),('Thalion frontal DRAFT',v/'output/referencias-personagens/CHAR-054/inicio-Arco01-conselheiro/r01/thalion-front-candidate-v01.png'),('Thalion nominal',v/'15_Fontes/Referências Visuais/Desktop Nottgard/thalion.jpg'),('Bromnor frontal DRAFT',v/'output/referencias-personagens/CHAR-010/historico-em-vida/r01/bromnor-front-candidate-v01.png'),('Brook retrato atual',r/'assets/portraits/brook.png'),('Maelor retrato atual',r/'assets/portraits/maelor.png'),('Leoric retrato atual',r/'assets/portraits/leoric.png'),('Korrak retrato atual',r/'assets/portraits/korrak.png'),('Kayron branco frontal',r/'.atena/generated/hq03-production-20261017/reference-audit/kayron-white-front.png'),('Sylas retrato atual',r/'assets/portraits/sylas.png'),('Bromnor retrato atual',r/'assets/portraits/bromnor.png')]
arts=[(p.name,p) for p in sorted((r/'assets/hq').glob('hq_n11_q*.png'))]
arts += [(p.name,p) for p in sorted((r/'assets/hq').glob('hq_n03_q*.png'))]
names=['hq_n03_q1_garden_v03.png','hq_n03_q5_living_veil_v01.png','hq_n03_q6_nottgard_protected_v01.png','hq_n18_q5_recovery_v01.png','hq_n16_q5_roots_v02.png','hq_n15_q1_beyond_tarn_v02.png','hq_n14_q5_hidden_base_v01.png']
arts += [(name,r/'assets/hq/chapter1_r1'/name) for name in names]
arts += [('Kayron canon branco',r/'.atena/generated/hq03-production-20261017/q1-v02-character-reference-sheet.jpg')]
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',16)
def sheet(rows,name,tw,th,cols):
    canvas=Image.new('RGB',(cols*tw,math.ceil(len(rows)/cols)*th),(22,24,30)); draw=ImageDraw.Draw(canvas)
    for i,(label,path) in enumerate(rows):
        assert path.is_file(),path
        with Image.open(path) as im: thumb=ImageOps.contain(im.convert('RGB'),(tw-12,th-42))
        x=(i%cols)*tw;y=(i//cols)*th
        canvas.paste(thumb,(x+(tw-thumb.width)//2,y+4))
        draw.text((x+6,y+th-32),label[:42],font=font,fill=(240,240,240))
    canvas.save(out/name)
sheet(refs,'references-r1.jpg',300,320,4)
sheet(arts,'reuse-audit-r1.jpg',350,235,4)
manifest=[]
for kind,rows in [('identity',refs),('reuse_candidate',arts)]:
    for label,path in rows:
        with Image.open(path) as im: size=list(im.size)
        manifest.append(dict(label=label,kind=kind,path=path.as_posix(),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),size=size))
(out/'audit-r1.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(dict(references=len(refs),reuse_candidates=len(arts),sheets=['references-r1.jpg','reuse-audit-r1.jpg'])))
