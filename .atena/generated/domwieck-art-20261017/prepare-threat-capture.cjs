const fs=require('fs');const dir='.atena/generated/domwieck-art-20261017/';
let capture=fs.readFileSync(dir+'capture-s004.gd','utf8').replace('["domwieck","reino_abissal"]','["domwieck"]').replace('["arrival","plaza","target","garden","side_w","side_l","behind_building","tree_near","combat","combat_garden"]','["combat_garden"]');
capture=capture.replace('battle.pickups.clear()','battle.pickups.clear()\n\t\t\t\tbattle.projectiles.clear()\n\t\t\t\tbattle.zones.clear()');
capture=capture.replace('\t\t\t\tscene._sync()',`\t\t\t\tfor i in 8:
\t\t\t\t\tbattle.projectiles.append({"owner":"enemy" if i%2 else "hero","pos":battle.hero.pos+Vector2.from_angle(TAU*float(i)/8.0)*5.0,"dir":Vector2.RIGHT,"speed":0.0,"life":99.0,"p":{}})
\t\t\t\tbattle.zones.append({"owner":"enemy","kind":"telegraph","pos":battle.hero.pos+Vector2(3.8,-1.5),"radius":1.4,"delay":0.5,"total":1.2,"life":99.0})
\t\t\t\tscene._sync()`);
fs.writeFileSync(dir+'capture-threats.gd',capture);
fs.writeFileSync(dir+'validate-threats.ps1',fs.readFileSync(dir+'validate-s004.ps1','utf8').replace('.atena/generated/domwieck-art-20261017/capture-s004.gd','.atena/generated/domwieck-art-20261017/capture-threats.gd'));
