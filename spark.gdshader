shader_type canvas_item;

void fragment() {
	float f = max(0.0, 0.5 - length(UV - 0.5));
	COLOR = vec4(smoothstep(0.0, 0.1, f));
}
