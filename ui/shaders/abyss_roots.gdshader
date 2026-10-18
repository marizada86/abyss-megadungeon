shader_type canvas_item;
render_mode unshaded;

uniform sampler2D surface_art : source_color, filter_nearest, repeat_disable;
uniform sampler2D junction_art : source_color, filter_nearest, repeat_disable;
uniform sampler2D side_art : source_color, filter_nearest, repeat_disable;
uniform sampler2D depth_art : source_color, filter_nearest, repeat_disable;
uniform vec3 root_nodes[9];
uniform vec4 root_edges[12];
uniform float half_width = 3.0;
uniform float atlas_inset = 0.008;
uniform float side_height_px = 32.0;
uniform float depth_height_px = 76.0;
uniform float side_repeat_px = 320.0;
uniform float depth_repeat_px = 192.0;
uniform float depth_opacity = 0.28;
uniform float top_brightness = 0.9;
uniform float side_rows[5];
uniform bool debug_top_mask = false;
varying vec2 floor_position;

void vertex() {
	// Local vertices are already screen-projected by the existing Iso contract.
	floor_position = vec2(VERTEX.x / 64.0 + VERTEX.y / 32.0,
		VERTEX.y / 32.0 - VERTEX.x / 64.0);
}

float capsule_distance(vec2 p, vec4 edge) {
	vec2 ab = edge.zw - edge.xy;
	float along = clamp(dot(p - edge.xy, ab) / dot(ab, ab), 0.0, 1.0);
	return length(p - edge.xy - ab * along) - half_width;
}

float support_distance(vec2 p) {
	float best = 10000.0;
	for (int i = 0; i < 9; i++) {
		best = min(best, length(p - root_nodes[i].xy) - root_nodes[i].z);
	}
	for (int i = 0; i < 12; i++) {
		best = min(best, capsule_distance(p, root_edges[i]));
	}
	return best;
}

vec2 atlas_uv(vec2 uv, int variant) {
	vec2 cell = vec2(float(variant % 2), float(variant / 2));
	return (cell + mix(vec2(atlas_inset), vec2(1.0-atlas_inset), clamp(uv,vec2(0.0),vec2(1.0)))) * 0.5;
}

vec4 top_color(vec2 p, float boundary) {
	float edge_best = 10000.0;
	int edge_id = 0;
	for (int i = 0; i < 12; i++) {
		float distance = capsule_distance(p, root_edges[i]);
		if (distance < edge_best) { edge_best = distance; edge_id = i; }
	}
	vec4 edge = root_edges[edge_id];
	vec2 tangent = normalize(edge.zw-edge.xy);
	vec2 normal = vec2(-tangent.y,tangent.x);
	vec2 offset = p-edge.xy;
	vec2 uv = vec2((dot(offset,tangent)+half_width)/(length(edge.zw-edge.xy)+half_width*2.0), dot(offset,normal)/(half_width*2.0)+0.5);
	vec3 color = texture(surface_art,atlas_uv(uv,edge_id%4)).rgb;
	float node_distance = 10000.0;
	int node_id = 0;
	for (int i = 0; i < 9; i++) {
		float distance = length(p-root_nodes[i].xy)/root_nodes[i].z;
		if (distance < node_distance) {node_distance=distance; node_id=i;}
	}
	float strongest = 1.0-smoothstep(0.45,1.0,node_distance);
	// Circle shoulders outside every passage have no valid passage UV. Cover
	// them with junction bark instead of stretching a clamped texture border.
	strongest=max(strongest,smoothstep(-0.5,0.0,edge_best));
	vec3 node = root_nodes[node_id];
	vec2 node_uv = (p-node.xy)/(node.z*2.0)+0.5;
	color = mix(color,texture(junction_art,atlas_uv(node_uv,node_id%4)).rgb,strongest);
	// Subdued edge roll-off conveys the change of plane without a neon outline.
	color *= top_brightness * mix(1.0,0.65,smoothstep(-0.45,0.0,boundary));
	return vec4(color,1.0);
}

float edge_fraction(vec2 p, float height_px) {
	vec2 shift = vec2(height_px/32.0);
	float lo=0.0; float hi=1.0;
	for (int i=0; i<4; i++) {
		float mid=(lo+hi)*0.5;
		if (support_distance(p-shift*mid)<=0.0) {hi=mid;} else {lo=mid;}
	}
	return (lo+hi)*0.5;
}

void fragment() {
	vec2 p=floor_position;
	float boundary=support_distance(p);
	if (debug_top_mask) {
		COLOR=vec4(vec3(1.0),boundary<=0.0?1.0:0.0);
	} else if (boundary<=0.0) {
		COLOR=top_color(p,boundary);
	} else {
		// Side/depth are strictly below the support, never over any walkable top.
		vec4 color=vec4(0.0);
		float screen_x=(p.x-p.y)*32.0;
		if (support_distance(p-vec2(depth_height_px/32.0))<=0.0) {
			float v=edge_fraction(p,depth_height_px);
			int variant=int(floor((screen_x+4000.0)/depth_repeat_px))%4;
			color=texture(depth_art,atlas_uv(vec2(fract((screen_x+4000.0)/depth_repeat_px),v),variant));
			color.rgb*=0.65;
			color.a*=depth_opacity;
		}
		if (support_distance(p-vec2(side_height_px/32.0))<=0.0) {
			float v=edge_fraction(p,side_height_px);
			int variant=int(floor((screen_x+4000.0)/side_repeat_px))%4;
			vec2 side_uv=vec2(mix(atlas_inset,1.0-atlas_inset,fract((screen_x+4000.0)/side_repeat_px)),mix(side_rows[variant]+0.004,side_rows[variant+1]-0.004,v));
			vec4 side=texture(side_art,side_uv);
			side.rgb*=0.78;
			float alpha=side.a+color.a*(1.0-side.a);
			color=vec4((side.rgb*side.a+color.rgb*color.a*(1.0-side.a))/max(alpha,0.0001),alpha);
		}
		COLOR=color;
	}
}
