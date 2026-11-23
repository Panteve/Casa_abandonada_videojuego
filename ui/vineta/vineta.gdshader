shader_type canvas_item;

// 0 = sin viñeta, 1 = bordes casi cerrados (la presencia está por llegar)
uniform float intensidad : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color_borde : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float suavidad : hint_range(0.05, 1.0) = 0.45;

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float d = length(uv) * 1.414;           // 0 en el centro, 1 en las esquinas
	float radio = mix(1.2, 0.35, intensidad);
	float a = smoothstep(radio - suavidad, radio, d);
	COLOR = vec4(color_borde.rgb, a * color_borde.a);
}
