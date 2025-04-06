shader_type canvas_item;

uniform vec4 shadow_color = vec4(0,0,0,0.2);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	COLOR = shadow_color * texture(TEXTURE, UV).a;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
