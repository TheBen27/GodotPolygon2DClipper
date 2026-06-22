shader_type canvas_item;

#define MAX_POINTS 256

varying vec2 world_pos;

uniform vec2 point_positions[MAX_POINTS];
uniform int points;
uniform sampler2D indexPalette;

float rand(float n){return fract(sin(n) * 43758.5453123);}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 0.0)).xy;
}

void fragment() {
	if (points == 0) {
		COLOR = texture(indexPalette, vec2(0.0));
	} else {
		int closest_index = 0;
		float closest_distance = 1e3;
		for (int i = 0; i < points; i++) {
			float d = distance(point_positions[i], world_pos);
			if (d < closest_distance) {
				closest_index = i;
				closest_distance = d;
			}
		}
		COLOR = texture(indexPalette, vec2(rand(float(closest_index)), 0.0));
	}
}
