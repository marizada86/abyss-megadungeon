import json, numpy as np, soundfile as sf, sys
v=json.load(open('audition_lote1/resultado.json')); items=json.load(open('audition_lote1/items.json'))
def feat(a):
    a=a-a.mean(); S=np.abs(np.fft.rfft(a*np.hanning(len(a))))**2; f=np.fft.rfftfreq(len(a),1/22050)
    tot=S.sum()+1e-12
    return (f*S).sum()/tot, S[f>4000].sum()/tot, np.sqrt((a**2).mean())
rows=[]
for it in items:
    n=it['n']; cur=sf.read(f'audition_lote1/sfx/i{n}_atual.wav')[0]
    for k in it['kinds'][1:]:
        nw=sf.read(f'audition_lote1/sfx/i{n}_{k}.wav')[0]
        rows.append((feat(cur),feat(nw),v[it['event']]==k))
R=np.array([[a[0],b[0],a[1],b[1],a[2],b[2]] for a,b,_ in rows])
print('centroide Hz  atual %.0f  novo %.0f'%(R[:,0].mean(),R[:,1].mean()))
print('energia >4kHz atual %.2f  novo %.2f'%(R[:,2].mean(),R[:,3].mean()))
print('RMS atual %.3f novo %.3f'%(R[:,4].mean(),R[:,5].mean()))
