const fs=require('fs');const root='D:/dev/nottgard/games/godot/nottgard-survivors/';
for(const [p,a,b]of [['core/hero.gd',195,245],['core/terrain_layout.gd',270,310],['core/battle.gd',290,370],['ui/run.gd',90,150],['ui/ground.gd',1,45]]){console.log(p);console.log(fs.readFileSync(root+p,'utf8').split('\n').slice(a-1,b).join('\n'))}
