
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
uniform vec2 offset;
uniform vec2 size;
uniform vec2 zoom;

const vec4 GRASS_COLOR = vec4(0.1,0.4,0.1,1);

vec4 grayscale(vec4 i, float amount){
	float med = (i.r + i.g + i.b + i.a) / 4.;
	return vec4(med);
}

void fragment() {
	vec4 height = texture(map, (UV + offset)/ size / 100.);
	vec4 color = height * 2. + vec4(waterColor.rgb , 1);

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


	color = mix(texture(SCREEN_TEXTURE, backGroundUV),color, 0.2);

	COLOR = mix(color, waterColor, colorCorection) * float(height.r < 0.15);
	COLOR += GRASS_COLOR * (3. * height.r) * float(height.r >= 0.15);

}