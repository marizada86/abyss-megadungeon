const fs=require('fs');
for(const [p,a,b]of [['core/battle.gd',305,392],['core/battle.gd',1390,1515],['core/hero.gd',195,260],['ui/ground.gd',1,115],['ui/ground.gd',260,315],['tests/test_yggdrasil_art.gd',1,75]]){console.log('\n'+p+':'+a);console.log(fs.readFileSync(p,'utf8').split('\n').slice(a-1,b).join('\n'))}
console.log('ROOT CALLS');for(const p of ['core/battle.gd','core/hero.gd'])fs.readFileSync(p,'utf8').split('\n').forEach((l,i)=>{if(l.includes('TerrainLayout.root_'))console.log(p+':'+(i+1)+l)});
