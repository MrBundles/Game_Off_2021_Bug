shader_type canvas_item;

uniform float threshhold = 255.0;
uniform vec4 color_low : hint_color;
uniform vec4 color_high : hint_color;

void fragment(){
//	COLOR = texture(TEXTURE, UV);
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

	if(COLOR.r + COLOR.g + COLOR.b < threshhold){
		COLOR = color_low;
	}else{
		COLOR = color_high;
	}

	COLOR.a = texture(TEXTURE, UV).a;
}