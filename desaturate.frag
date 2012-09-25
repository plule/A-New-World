extern float desaturation_factor;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	vec4 c = color*Texel(texture,texture_coords);
	float gray = (c.r * 0.3 + c.g * 0.56 + c.b * 0.14); 
	return mix(vec4(gray,gray,gray,c.a), c, desaturation_factor);
}
