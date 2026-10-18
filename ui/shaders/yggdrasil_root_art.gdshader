shader_type canvas_item;
render_mode unshaded;
uniform sampler2D ground_art : source_color, filter_linear, repeat_disable;
uniform sampler2D edge_art : source_color, filter_linear, repeat_disable;
uniform sampler2D detail_art : source_color, filter_linear, repeat_disable;
uniform vec3 root_nodes[7];
uniform vec4 root_edges[8];
uniform float half_widths[8];
uniform vec4 side_rects[4];
uniform float side_height_px = 28.0;
uniform float top_brightness = 0.72;
uniform float detail_opacity = 0.16;
uniform bool debug_top_mask = false;
varying vec2 floor_position;
void vertex() {
 floor_position = vec2(VERTEX.x/64.0+VERTEX.y/32.0,VERTEX.y/32.0-VERTEX.x/64.0);
}
float capsule_distance(vec2 p, int i) {
 vec4 e=root_edges[i]; vec2 ab=e.zw-e.xy;
 return length(p-e.xy-ab*clamp(dot(p-e.xy,ab)/dot(ab,ab),0.0,1.0))-half_widths[i];
}
float support_distance(vec2 p) {
 float d=10000.0;
 for(int i=0;i<7;i++){d=min(d,length(p-root_nodes[i].xy)-root_nodes[i].z);}
 for(int i=0;i<8;i++){d=min(d,capsule_distance(p,i));}
 return d;
}
// Mirrored sampling keeps adjacent repetitions continuous, without editing sources.
vec2 mirrored(vec2 p) {return vec2(1.0)-abs(mod(p,vec2(2.0))-vec2(1.0));}
vec3 wood(vec2 uv) {
 vec3 c=texture(ground_art,mix(vec2(0.008),vec2(0.992),mirrored(uv))).rgb;
 float l=dot(c,vec3(0.2126,0.7152,0.0722));
 return mix(vec3(l),c,0.72)*top_brightness;
}
vec4 surface(vec2 p,float boundary) {
 int closest=0;int second=0;float best=10000.0;float next_best=10000.0;
 for(int i=0;i<8;i++){
  float d=capsule_distance(p,i);
  if(d<best){next_best=best;second=closest;best=d;closest=i;}
  else if(d<next_best){next_best=d;second=i;}
 }
 vec4 e=root_edges[closest];vec2 tangent=normalize(e.zw-e.xy);
 vec2 normal=vec2(-tangent.y,tangent.x);vec2 delta=p-e.xy;
 vec2 uv=vec2(dot(delta,tangent)/12.0,dot(delta,normal)/12.0+0.5);
 vec3 c=wood(uv);
 // Blend the two incident grain fields at their shared boundary, rather than
 // making a hard rectangular change of texture direction at a junction.
 vec4 other=root_edges[second];vec2 t2=normalize(other.zw-other.xy);
 vec2 n2=vec2(-t2.y,t2.x);vec2 delta2=p-other.xy;
 vec2 uv2=vec2(dot(delta2,t2)/12.0,dot(delta2,n2)/12.0+0.5);
 c=mix(c,wood(uv2),0.5*(1.0-smoothstep(0.0,1.5,next_best-best)));
 // Blend node shoulders smoothly with a fixed material field; no clamped borders.
 float nearest=10000.0;int node_id=0;
 for(int i=0;i<7;i++){float d=length(p-root_nodes[i].xy)/root_nodes[i].z;if(d<nearest){nearest=d;node_id=i;}}
 vec3 n=root_nodes[node_id];vec2 local=(p-n.xy)/(n.z*2.0)+0.5;
 float influence=(1.0-smoothstep(0.25,0.95,nearest));
 influence=max(influence,smoothstep(-0.7,0.0,best));
 c=mix(c,wood(vec2(p.y/12.0,p.x/12.0)),influence*0.65);
 if(nearest<0.7){
  vec2 cell=vec2(float(node_id%2),float((node_id/2)%2));
  vec4 detail=texture(detail_art,(cell+mix(vec2(0.008),vec2(0.992),clamp(local,vec2(0.0),vec2(1.0))))*0.5);
  c=mix(c,detail.rgb*top_brightness,detail.a*detail_opacity*influence);
 }
 c*=mix(1.0,0.6,smoothstep(-0.35,0.0,boundary));
 return vec4(c,1.0);
}
void fragment() {
 vec2 p=floor_position;float d=support_distance(p);
 if(debug_top_mask){COLOR=vec4(vec3(1.0),d<=0.0?1.0:0.0);}
 else if(d<=0.0){COLOR=surface(p,d);}
 else if(support_distance(p-vec2(side_height_px/32.0))<=0.0){
  float lo=0.0;float hi=1.0;
  for(int i=0;i<5;i++){float mid=(lo+hi)*0.5;if(support_distance(p-vec2(side_height_px/32.0)*mid)<=0.0){hi=mid;}else{lo=mid;}}
  float v=(lo+hi)*0.5;float sx=(p.x-p.y)*32.0;float u=(sx+5000.0)/400.0;
  int variant=int(floor(u))%4;vec4 rect=side_rects[variant];
  vec4 bark=texture(edge_art,rect.xy+vec2(mirrored(vec2(u,0.0)).x,v)*rect.zw);
  // Continuous dark side under translucent atlas fibers, bounded by extrusion.
  COLOR=vec4(mix(vec3(0.07,0.045,0.035),bark.rgb*0.48,bark.a),1.0);
 }else{COLOR=vec4(0.0);}
}
