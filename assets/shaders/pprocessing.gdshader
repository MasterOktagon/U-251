shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
/*uniform vec2 size = vec2(32.0, 28.0);
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.

vec4 grayscale(vec4 i){
	float med = (i.r + i.g + i.b )/3.;//+ i.a) / 4.;
	return vec4(med, med, med, i.a);
}

void fragment() {
        COLOR = grayscale(texture(screen_texture, SCREEN_UV));
}*/

vec4 grayscale(vec4 i, float amount){
	float med = (i.r + i.g + i.b )/3.;//+ i.a) / 4.;
	return vec4(i.r*amount+med*(1.-amount), i.g*amount+med*(1.-amount), i.b*amount+med*(1.-amount), i.a);
}

//original author : Wagner  https://github.com/spite/Wagner/blob/master/fragment-shaders/old-video-fs.glsl
//original shader in godot2: airvikar https://www.youtube.com/watch?v=KlyTvUE2WJI
//translation from godot2 to godot3 : axeltherabbit https://gist.github.com/Axeltherabbit/f8075aba20096fd2f5b5206d97b9fc8c
float randi(vec2 co){return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);} 
float rand(float c){return randi(vec2(c,1.0));} 

float randomLine(float seed, vec2 uv){
	float b= 0.01*rand(seed);
	float a= rand(seed+1.0);
	float c = rand(seed+2.0)-0.5;
	float mu = rand(seed+3.0);
	float l = 1.0;
	if (mu > 0.2) {l = pow(abs(a * uv.x + b * uv.y + c),1.0/8.0);}
	else {l = 2.0-pow(abs(a * uv.x + b * uv.y + c),1.0/8.0);}
	return mix(0.5,1.0,l);}
	
float randomBlotch(float seed, vec2 uv){
	float x = rand(seed);
	float y = rand(seed+1.0);
	float s = 0.01 * rand(seed+2.0);
	vec2 p =vec2(x,y) - uv;
	float a = atan(p.y/p.x);
	float v = 1.0;
	float ss = s*s* (sin(6.2831*a*x)*0.1+1.0);
	if (dot(p,p) < ss) {v=0.2;}
	else {v = pow(dot(p,p)-ss, 1.0/16.0);}
	return mix(0.3 + 0.2 * (1.0-(s/0.02)),1.0,v); }


void fragment(){
	vec2 uv = UV;
	float t = float(TIME*15.0);
	vec2 suv = uv+0.002*vec2(rand(t),rand(t+23.0)); 
	//oldcode image = tex(TEXTURE, suv.xy).xyz;
	vec3 image = texture(TEXTURE, vec2(suv.x/1024.0, suv.y/600.0)).rgb;
	float luma = dot(vec3(0.2126,0.7152,0.0722), image);
	vec3 oldImage = luma * vec3(0.7,0.7,0.7);
	
	float vI = 16.0 * (uv.x * (1.0-uv.x)* uv.y*(1.0-uv.y));
	
	vI *= mix(0.7,1.0, rand(t+0.5));
	vI += 1.0 + 0.4* rand(t+8.0);
	vI *= pow(16.0 * uv.x * (1.0-uv.x)* uv.y*(1.0-uv.y), 0.4);
	
	float l = (8.0 * rand(t+7.0));
	
	for (float i = 0.0; i < 8.0 ; i++) {
		if (i<l) {vI *= randomLine(t+6.0+17.0* i, uv);}}
		
	
	float s = ( max(8.0 * rand(t+18.0)-2.0,0.0));
	
	for (float i = 0.0; i < 6.0 ; i++) {
		if (i < s) {vI *= randomBlotch(t+6.0+19.0*i, uv);}}
	
	COLOR = grayscale(texture(screen_texture, UV), 0.5);
	COLOR.rgb = (oldImage*vI*COLOR.rgb + COLOR.rgb*5.)/6.;
	COLOR *= (1.0+(randi(uv+vec2(t*0.01))-0.2)*0.45);
}
