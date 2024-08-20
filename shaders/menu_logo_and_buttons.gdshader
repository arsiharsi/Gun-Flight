shader_type canvas_item;

void fragment(){
	vec2 transform;
	transform = vec2((UV.x + UV.y) * sin(TIME/2.0), (UV.y + UV.x) * cos(TIME/2.0));
	COLOR = texture(TEXTURE,UV + transform * 0.02) * vec4(cos(TIME/4.0),transform.x , transform.y,1.0);
}