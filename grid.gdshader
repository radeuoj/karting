shader_type spatial;

uniform vec3 line_color: source_color = vec3(0.7);
uniform float zoom: hint_range(1.0, 1000.0, 0.1) = 100.0;

float draw_grid(vec2 uv) {
	//vec2 grid_uv = fract(uv);
	//return max(grid_uv.x, grid_uv.y);
	ivec2 grid_uv = ivec2(floor(uv));
	if (grid_uv.x % 2 == grid_uv.y % 2) return 0.3;
	else return 0.7;
}

void fragment() {
	vec2 uv = UV;

	float color = draw_grid(uv * zoom);
	ALBEDO = color * line_color;
	//ALPHA = color;

}
