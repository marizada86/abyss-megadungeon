import json, numpy as np, soundfile as sf, os, shutil
from scipy.signal import butter, sosfilt
A='audition_lote1'; O='audition_suave'; os.makedirs(O+'/sfx',exist_ok=True)
v=json.load(open(A+'/resultado.json')); items=json.load(open(A+'/items.json'))
sel=[i for i in items if v[i['event']].startswith('novo') and i['group'] in ('S-sfx-combat','S-sfx-player','S-sfx-ui','S-sfx-progress')]
pick=[]; seen=set()
for i in sel:
    if i['group'] not in seen or len(pick)<12: pick.append(i); seen.add(i['group'])
    if len(pick)==12: break
out=[]
lp=butter(4,4500,'low',fs=22050,output='sos'); lowb=butter(2,[80,250],'band',fs=22050,output='sos')
for k,i in enumerate(pick,1):
    n='%03d'%k; cur,_=sf.read(f"{A}/sfx/i{i['n']}_atual.wav"); nw,_=sf.read(f"{A}/sfx/i{i['n']}_{v[i['event']]}.wav")
    s=sosfilt(lp,nw)+0.5*sosfilt(lowb,nw)           # corta agudos acima de 4,5 kHz e reforca o corpo grave
    s=s/(abs(s).max() or 1)*abs(nw).max()
    for kind,a in (('atual',cur),('novo_01',nw),('novo_02',s)): sf.write(f'{O}/sfx/i{n}_{kind}.wav',np.clip(a,-1,1),22050,subtype='PCM_16')
    out.append({**i,'n':n,'kinds':['atual','novo_01','novo_02'],'targets':[]})
json.dump(out,open(O+'/items.json','w'),indent=1)
for f in('main.gd','main.tscn','project.godot'): shutil.copy('audition_template/'+f,O+'/'+f)
print(len(out),[i['event'] for i in out])
