shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0) = 0.0;
uniform vec4 desired_colour : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 base_color = COLOR;

    base_color.rgb += desired_colour.rgb * lerp_percent;

    COLOR = base_color;
}