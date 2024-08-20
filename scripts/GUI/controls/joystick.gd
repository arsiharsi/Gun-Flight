extends Control
export (String,"left","right") var side = "left"
signal joystick_out(direction, is_shooting)
var start_pos = Vector2.ZERO
export var scale_multiplier = 1.0
export var drag_length = 30.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_scale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalSceneScript.is_pc_port:
		hide()
	start_pos = rect_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	new_scale = (get_viewport_rect().size.x/1024 + get_viewport_rect().size.y/576)/2
	new_scale = new_scale*scale_multiplier
	$body.scale = Vector2(new_scale*drag_length/5, new_scale*drag_length/5)
	$joycon.scale = Vector2(new_scale, new_scale)
	if not $joycon.is_pressed():
		$joycon.position = Vector2.ZERO
		rect_position = start_pos
	if GlobalSceneScript.is_pc_port:
		keyboard_movement()
	if $joycon.position.length() < drag_length*new_scale and $joycon.position.length() != 0:
		emit_signal("joystick_out",$joycon.position.clamped(10),false)
	elif $joycon.position.length() >= drag_length*new_scale:
		emit_signal("joystick_out",$joycon.position.clamped(10),true)
	
	pass


func keyboard_movement():
	var drag = Vector2.ZERO
	if side == "left":
		drag.x = (int(Input.is_action_pressed("p1_right"))-int(Input.is_action_pressed("p1_left")))*drag_length*new_scale*2
		drag.y = (int(Input.is_action_pressed("p1_down"))-int(Input.is_action_pressed("p1_up")))*drag_length*new_scale*2
		if drag.length() > 0:
			$joycon.position = drag
	else:
		drag.x = (int(Input.is_action_pressed("p2_right"))-int(Input.is_action_pressed("p2_left")))*drag_length*new_scale*2
		drag.y = (int(Input.is_action_pressed("p2_down"))-int(Input.is_action_pressed("p2_up")))*drag_length*new_scale*2
		if drag.length() > 0:
			$joycon.position = drag


func _input(event):
	if event is InputEventScreenTouch:
		if side == "left":
			if $joycon.is_pressed() and event.position.x < get_viewport_rect().size.x/2:
				rect_global_position = event.position
		if side == "right":
			if $joycon.is_pressed() and event.position.x > get_viewport_rect().size.x/2:
				rect_global_position = event.position
	elif event is InputEventScreenDrag:
		if side == "left":
			if $joycon.is_pressed() and event.position.x < get_viewport_rect().size.x/2:
				$joycon.global_position = event.position
				if $joycon.position.length() > drag_length*new_scale * 2:
					rect_global_position = event.position - rect_global_position.direction_to(event.position) * (drag_length*new_scale*2)
				$joycon.position = $joycon.position.clamped(drag_length*new_scale)
		if side == "right":
			if $joycon.is_pressed() and event.position.x > get_viewport_rect().size.x/2:
				$joycon.global_position = event.position
				if $joycon.position.length() > drag_length*new_scale * 2:
					rect_global_position = event.position - rect_global_position.direction_to(event.position) * (drag_length*new_scale*2)
				$joycon.position = $joycon.position.clamped(drag_length*new_scale)
		pass
