shader_type canvas_item;

uniform vec2 size = vec2(32.0, 28.0);
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec4 grayscale(vec4 i){
	float med = (i.r + i.g + i.b )/3.;//+ i.a) / 4.;
	return vec4(med, med, med, i.a);
}

void fragment() {
        COLOR = grayscale(texture(screen_texture, SCREEN_UV));
}
