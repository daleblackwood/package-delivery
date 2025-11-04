shader_type spatial;
render_mode unshaded, depth_draw_never;

uniform vec4 color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
	float lum = clamp(pow(dot(normalize(NORMAL), normalize(VIEW)), 2.0), 0.0, 0.6);
	ALPHA = lum;
	ALBEDO = vec3(0, 0, 0);
}