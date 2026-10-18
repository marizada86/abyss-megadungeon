const fs=require('fs');let p='core/battle.gd',s=fs.readFileSync(p,'utf8');
s=s.replace('func _root_grid(radius: float) -> Dictionary:',`func _root_grid_step(radius: float) -> float:
\treturn 0.5 if stage_id == "raiz_yggdrasil" and radius > 0.8 else 1.0

func _root_grid(radius: float) -> Dictionary:`);
s=s.replace('for y in int(map_size.y):\n\t\tfor x in int(map_size.x):\n\t\t\tif hero.can_stand(Vector2(x + 0.5, y + 0.5), float(bucket) / 10.0 + 0.71):','var step := _root_grid_step(radius)\n\tfor y in int(map_size.y / step):\n\t\tfor x in int(map_size.x / step):\n\t\t\tif hero.can_stand((Vector2(x,y) + Vector2(0.5,0.5)) * step, float(bucket) / 10.0 + 0.71 * step):');
s=s.replace('func _root_cell(p: Vector2, cells: Dictionary) -> Vector2i:\n\tvar cell := Vector2i(floor(p.x), floor(p.y))','func _root_cell(p: Vector2, cells: Dictionary, step: float = 1.0) -> Vector2i:\n\tp /= step\n\tvar cell := Vector2i(floor(p.x), floor(p.y))');
s=s.replaceAll('_root_cell(target, cells)','_root_cell(target, cells, _root_grid_step(radius))').replace('_root_cell(from, cells)','_root_cell(from, cells, _root_grid_step(radius))');
s=s.replace('var waypoint := Vector2(next) + Vector2(0.5, 0.5)','var waypoint := (Vector2(next) + Vector2(0.5, 0.5)) * _root_grid_step(radius)');
s=s.replace('_root_cell(at, _root_grid(radius))','_root_cell(at, _root_grid(radius), _root_grid_step(radius))');
s=s.replace('var candidate := Vector2(cell) + Vector2(0.5, 0.5)','var candidate := (Vector2(cell) + Vector2(0.5, 0.5)) * _root_grid_step(radius)');
fs.writeFileSync(p,s);
p='tests/test_yggdrasil_navigation.gd';s=fs.readFileSync(p,'utf8').replace('_root_cell(Vector2(30,48),cells)','_root_cell(Vector2(30,48),cells,b._root_grid_step(radius))');fs.writeFileSync(p,s);
console.log('Half-unit safe AI grid for Yggdrasil footprints > 0.8; existing grid preserved otherwise.');
