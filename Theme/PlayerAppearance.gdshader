shader_type canvas_item;

uniform sampler2D original_palette;
uniform sampler2D replace_palette;
uniform vec4 original_eye : hint_color;
uniform vec4 eye_color : hint_color;

void fragment(){
	
	vec4 original1 = texture(original_palette,vec2(0.17,0));
	vec4 original2 = texture(original_palette,vec2(0.5,0));
	vec4 original3 = texture(original_palette,vec2(0.83,0));

	vec4 replace1 =  texture(replace_palette,vec2(0.17,0));
	vec4 replace2 =  texture(replace_palette,vec2(0.5,0));
	vec4 replace3 =  texture(replace_palette,vec2(0.83,0));
	
	vec4 character_skin = texture(TEXTURE, UV);
		
	if (character_skin == original1){
		COLOR = replace1
	}
	else if (character_skin == original2){
		COLOR = replace2
	}
	else if (character_skin == original3){
		COLOR = replace3
	}
	else if (distance(character_skin, original_eye) <0.05) {
		COLOR = eye_color
	}
	else {
		COLOR.rgb = character_skin.rgb
	}
	COLOR.a = character_skin.a;
}