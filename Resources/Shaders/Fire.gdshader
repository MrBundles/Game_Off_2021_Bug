/* 
Original shader from Fubucci – https://www.febucci.com/2019/05/fire-shader/ 
Converted to Godot Shader Language by Godot Shaders - godotshaders.com/shader/2D-fire/
*/

shader_type canvas_item;

uniform sampler2D noise_tex;
uniform sampler2D gradient_tex;
uniform float speed = 1.0;

uniform vec4 brighter_color : hint_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 middle_color : hint_color  = vec4(1.0, 0.56, 0.0, 1.0);
uniform vec4 darker_color : hint_color  = vec4(0.64, 0.2, 0.05, 1.0);

uniform float spread : hint_range(0.0, 1.0) = 0.5;

void fragment()
{
	
	float noise_value = texture(noise_tex, UV + vec2(0.0, TIME * speed)).x;
	// The .yx swizzle is when using the built in horizontal gradient texture. If you have a vertical gradient texture remove .yx
	float gradient_value = texture(gradient_tex, UV.yx).x;
	
	gradient_value -= smoothstep(spread, spread + 0.5, length(UV + vec2(-0.5, -0.5)) / spread);
	
	float step1 = step(noise_value, gradient_value);
	float step2 = step(noise_value, gradient_value - 0.2);
	float step3 = step(noise_value, gradient_value - 0.4);
	
	vec4 bd_color = mix(brighter_color.rgba, darker_color.rgba, step1 - step2);
	
	vec4 color = bd_color;
	color.rgba = mix(color.rgba, middle_color.rgba, step2 - step3);
	
	COLOR = color;
}