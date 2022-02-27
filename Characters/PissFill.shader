shader_type spatial;
render_mode blend_mix;

uniform sampler2D tex : hint_albedo;
uniform float piss : hint_range(0.0, 1.0) = 0.5;
uniform vec4 color : hint_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
	vec3 c = texture(tex, UV).rgb * 0.8;
	float f = clamp(UV.y * 50.0 - 50.0 * (0.95 - piss), 0.0, 1.0);
	ALBEDO = mix(c, color.rgb, f * 0.5);
	METALLIC = 0.2;
	SPECULAR = 0.4;
	ROUGHNESS = 0.0;
}