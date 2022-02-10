shader_type spatial;

uniform sampler2D tex;
uniform float piss : hint_range(0.0, 1.0) = 0.5;
uniform vec4 color : hint_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
	vec3 c = texture(tex, UV).rgb;
	float f = clamp(UV.y * 50.0 - 50.0 * (1.0 - piss), 0.0, 1.0);
	ALBEDO = mix(c, color.rgb, f * 0.5);
}