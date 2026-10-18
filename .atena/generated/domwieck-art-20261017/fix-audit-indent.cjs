const fs=require('fs');const p='.atena/generated/domwieck-art-20261017/render-audit.gd';
fs.writeFileSync(p,fs.readFileSync(p,'utf8').replace(/^ +/gm,s=>'\t'.repeat(s.length)));
