
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_enable, filter_nearest;

group_uniforms water;
uniform sampler2D waterNoise : repeat_enable, filter_nearest;
uniform sampler2D waterDistortionNoise : repeat_enable, filter_nearest;
uniform vec4 waterColor : source_color = vec4(0.117, 0.27, 0.58, 1);
uniform float colorCorection : hint_range(0.0, 1.0, 0.01) = 0.35;

group_uniforms water_waves;
uniform float distortionForce : hint_range(0.00, .1, 0.001) = .01;
uniform float WDBrightness : hint_range(0, 3, 0.05) = 1.5;
uniform float WDFreq : hint_range(0.2, .9, 0.05) = 0.6;
uniform float WDSize : hint_range(0.6, 1.2, 0.05) = .9;
uniform float WDSpeed : hint_range(1, 20, 0.05) = 4;
uniform vec2 tiling = vec2(1);
uniform vec2 offSetSpeed = vec2(.1);

group_uniforms BG_distortion;
uniform float backGroundDirX : hint_range(-0.1, 0.1) = 0.01;
uniform float backGroundDirY : hint_range(-0.1, 0.1) = 0.01;

group_uniforms map;
uniform sampler2D map;
uniform float sealevel;
uniform vec2 offset;
uniform vec2 size;
uniform vec2 sizePx;
uniform vec2 zoom;

const vec4 GRASS_COLOR = vec4(0.1,0.4,0.1,1);

float grayscale(vec4 i){
	float med = (i.r + i.g + i.b) / 3.;
	return med;
}

void fragment() {
	//vec4 height = texture(map, (offset + vec2(2048.) + size/2.) / (4096. * 1.) + UV/1.);//(UV /3. - 3.*(vec2(2048.)/TEXTURE_PIXEL_SIZE) + offset / size / 3.));
	float height = grayscale(texture(map, UV));
	
	float heightmin = -2000.;
	float heightmax = 550.;
	float heightmetres = heightmin + (heightmax-heightmin)*height;
	
	vec4 color = vec4(vec3(height),1);
	if (heightmetres>sealevel){
		color = GRASS_COLOR;
		COLOR = color;
	}
	else{
		color.rgb = waterColor.rgb * (height+0.4)*2.5;
	
	
	//COLOR = vec4(color.rgb,1.);
	
	//vec4 color = vec4(waterColor.rgb * height.r, 1.);

	vec2 noiseUV = UV * tiling + offSetSpeed * TIME + offset / size;
	//noiseUV /= zoom;
	//noiseUV += (size) / 2.;
	float noiseValue = texture(waterDistortionNoise, noiseUV).r;

	vec2 waterUV = UV * tiling + offset / size;
	waterUV.x += offSetSpeed.x * TIME;
	waterUV.y += cos(TIME * min(1., offSetSpeed.y)) * 0.01;
	//waterUV /= zoom;
	//waterUV += (size) / 2.;
	waterUV = waterUV + noiseValue * distortionForce * WDSpeed;


	vec4 noiseColor = texture(waterNoise, waterUV);
	float intensity = smoothstep(WDFreq, WDSize, noiseColor.r);
	color.rgb += intensity * vec3(WDBrightness);

	vec2 backGroundUV = SCREEN_UV;
	backGroundUV.x += noiseValue * backGroundDirX;
	backGroundUV.y += noiseValue * backGroundDirY;


	color = mix(texture(SCREEN_TEXTURE, backGroundUV),color, 1);

	COLOR = mix(color, waterColor, colorCorection);// * float(height > 0./255.);
	}
	//COLOR += GRASS_COLOR * (3. * height) * float(height >= 100./255.);
	
	//COLOR = color;// * float(height.r < 100./255.);

}