extends Area2D
export (NodePath) var control_base
export (NodePath) var enemy
var to_avoid
var is_rigid
var is_active = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_active_ai(state:bool):
	is_active = state
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_node_or_null(control_base) and get_node_or_null(enemy) and is_active:
		var base = get_node_or_null(control_base)
		global_position = base.global_position
		var target = get_node_or_null(enemy)
		var pursuit = base.global_position.distance_to(target.global_position) > 400 
		pursuit = pursuit and not base.weapon == "knife"
		var position_difference = target.global_position-base.global_position
		var direction = (1-2*int(pursuit))*base.global_position.direction_to(target.global_position)
		if GlobalSceneScript.is_pc_port:
			direction = turn_direction_8_way(direction, position_difference)
		if not pursuit:
			base.call_deferred("_on_joystick", direction, true)
		else:
			if to_avoid:
				var add_dir = Vector2()
				if is_rigid:
					add_dir.y = to_avoid.linear_velocity.x*sign(to_avoid.global_position.y-base.global_position.y)
					add_dir.x = to_avoid.linear_velocity.y*sign(to_avoid.global_position.x-base.global_position.x)
					base.call_deferred("_on_joystick", direction + add_dir, true)
				else:
					add_dir.y = to_avoid.speed * to_avoid.dir.y*sign(to_avoid.global_position.y-base.global_position.y)
					add_dir.x = to_avoid.speed * to_avoid.dir.x*sign(to_avoid.global_position.x-base.global_position.x)
					base.call_deferred("_on_joystick", direction + add_dir, true)
			else:
				base.call_deferred("_on_joystick", direction, true)
	pass

func turn_direction_8_way(in_dir, pos_dif):
	var saved_dir = in_dir
	if abs(pos_dif.x) < 66:
		saved_dir.y = 0
	elif abs(pos_dif.y) < 66:
		saved_dir.y = 0
	var new_dir = Vector2(sign(saved_dir.x),sign(saved_dir.y))
	return new_dir


func _on_vsbot_ai_body_entered(body):
	if body:
		if get_node_or_null(control_base):
			if body.player_shot != get_node_or_null(control_base).player:
				to_avoid = body
				is_rigid = body.get_class() == "RigidBody2D"
	pass # Replace with function body.


func _on_vsbot_ai_body_exited(body):
	if body:
		if to_avoid == body:
			to_avoid = null
	pass # Replace with function body.
