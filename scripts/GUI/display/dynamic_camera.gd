extends Camera2D
export (NodePath) var first_object
export (NodePath) var second_object
export var zoom_speed = 5.0
var zoom_end = Vector2.ZERO
var position_end = Vector2.ZERO
export var bottom_zoom_val = 0.4
export var top_zoom_val = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if first_object and second_object:
		var first = get_node(first_object).global_position
		var second = get_node(second_object).global_position
		position_end = (first + second)/2
		global_position += (position_end - global_position)/zoom_speed
		zoom_end.x = abs((second-first).x)/get_viewport_rect().size.x+0.2
		zoom_end.y = abs((second-first).y)/get_viewport_rect().size.y+0.2
		if zoom_end.x > zoom_end.y:zoom_end.y = zoom_end.x
		else:zoom_end.x = zoom_end.y
		if zoom_end.x < bottom_zoom_val:
			zoom_end = Vector2(bottom_zoom_val, bottom_zoom_val)
		zoom += (zoom_end - zoom)/zoom_speed
		if top_zoom_val != 0:
			zoom = Vector2(clamp(zoom.x, 0, top_zoom_val), clamp(zoom.y, 0, top_zoom_val))
		GlobalSceneScript.zoom_screen = zoom.x
	pass
