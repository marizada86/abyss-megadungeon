const fs=require('fs'),path=require('path');const base='.atena/generated/path-revision-20261017';const files=['core/terrain_layout.gd','ui/shaders/yggdrasil_root_art.gdshader'];for(const p of files){const dest=base+'/s004-opt-before/'+p;fs.mkdirSync(path.dirname(dest),{recursive:true});fs.copyFileSync(p,dest)}
let p=files[0],s=fs.readFileSync(p,'utf8');const start=s.indexOf('\tfor node: Array in d.nodes.values():',s.indexOf('static func root_supports('));const end=s.indexOf('\nstatic func root_nearest(',start);
if(start<0||end<0)throw Error('Support anchors');
s=s.slice(0,start)+`\tif not d.has("_support_cells"):
\t\t_index_root_support(d)
\tvar cell := int(floor(p.x)) + 64 * int(floor(p.y))
\tfor primitive: Array in d._support_cells.get(cell, []):
\t\tvar margin := float(primitive[2]) - radius
\t\tif margin < 0.0:
\t\t\tcontinue
\t\tvar a: Vector2 = primitive[0]
\t\tvar b: Vector2 = primitive[1]
\t\tvar center := a if a == b else Geometry2D.get_closest_point_to_segment(p,a,b)
\t\tif p.distance_to(center) <= margin:
\t\t\treturn true
\treturn false

static func _index_root_support(d: Dictionary) -> void:
\t# Immutable geometry, derived index owned by the same definition/battle.
\t# Only primitives whose un-eroded bounds contain this cell can support a body.
\tvar cells: Dictionary = {}
\tvar primitives: Array = []
\tfor node: Array in d.nodes.values():
\t\tvar p := root_point(node)
\t\tprimitives.append([p,p,float(node[2])])
\tfor edge: Array in d.edges:
\t\tprimitives.append([root_point(d.nodes[edge[0]]),root_point(d.nodes[edge[1]]),root_edge_width(d,edge)*0.5])
\tfor primitive: Array in primitives:
\t\tvar a: Vector2 = primitive[0]
\t\tvar b: Vector2 = primitive[1]
\t\tvar radius := float(primitive[2])
\t\tvar lo := a.min(b)-Vector2.ONE*radius
\t\tvar hi := a.max(b)+Vector2.ONE*radius
\t\tfor y in range(int(floor(lo.y)),int(floor(hi.y))+1):
\t\t\tfor x in range(int(floor(lo.x)),int(floor(hi.x))+1):
\t\t\t\tvar key := x + 64*y
\t\t\t\tif not cells.has(key):
\t\t\t\t\tcells[key] = []
\t\t\t\tcells[key].append(primitive)
\td._support_cells = cells
`+s.slice(end);fs.writeFileSync(p,s);
p=files[1];s=fs.readFileSync(p,'utf8');const old='float d=10000.0;\n for(int i=0;i<node_count;i++){d=min(d,length(p-root_nodes[i].xy)-root_nodes[i].z);}\n for(int i=0;i<edge_count;i++){d=min(d,capsule_distance(p,i));}\n return d;';
const next=`// Consumers need exact distances only at the top rim (-0.35..0).
 // Positive distances are used only for the support predicate; deep negative
 // values have identical shading. Bounds therefore skip only irrelevant work.
 float d=1.0;
 for(int i=0;i<node_count;i++){
  vec3 n=root_nodes[i];
  if(any(greaterThan(abs(p-n.xy),vec2(n.z+1.0)))){continue;}
  d=min(d,length(p-n.xy)-n.z);
  if(d < -0.8){return d;}
 }
 for(int i=0;i<edge_count;i++){
  vec4 e=root_edges[i];float margin=half_widths[i]+1.0;
  if(any(lessThan(p,min(e.xy,e.zw)-vec2(margin))) || any(greaterThan(p,max(e.xy,e.zw)+vec2(margin)))){continue;}
  d=min(d,capsule_distance(p,i));
  if(d < -0.8){return d;}
 }
 return d;`;
if(!s.includes(old))throw Error('Shader support anchor');fs.writeFileSync(p,s.replace(old,next));console.log('Bounded optimization: instance-owned support cell index and exact-rim shader bounds. No geometry/criteria changes.');
