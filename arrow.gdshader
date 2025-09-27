shader_type spatial;

uniform vec3 color: source_color = vec3(1.0);
uniform float alpha = 1.0;

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}
