shader_type canvas_item;
uniform bool colored = false;
uniform float mix_weight = 1.0; //opacity alpha
uniform vec3 color =vec3(1,1,1);
void fragment() {
vec4 texture_color= texture(TEXTURE, UV);
if (colored) {
vec3 colored_texture_rgb =mix (texture_color.rgb, color.rgb, mix_weight);
COLOR = vec4(colored_texture_rgb, texture_color.a);
} else {
COLOR = texture_color
}
}