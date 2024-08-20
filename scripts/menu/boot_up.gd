extends Node2D

export var is_pc_port = false
var tutorial = load("res://tscnes/locs/tutorial.tscn")
var game = load("res://tscnes/menu/menu_1.tscn")
var damage = load("res://tscnes/menu/bootsplah_damage.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Bridge.platform.send_message("game_ready")
	GlobalSceneScript.load_from_bridge()
	GlobalSceneScript.loadSave()
	GlobalSceneScript.is_pc_port = is_pc_port
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	pass # Replace with function body.

func _on_visibility_state_changed(state):
	# visible, hidden
	AudioServer.set_bus_volume_db(0, -72*int(state == "hidden"))


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var d = damage.instance()
		var symbol = $cl/base/logo.get_child(int(rand_range(0, $cl/base/logo.get_child_count())))
		symbol.global_position += Vector2(rand_range(-25,25),rand_range(-25,25))
		symbol.global_rotation_degrees += rand_range(-10,10)
		symbol.self_modulate += Color.red
		add_child(d)
		d.global_position = symbol.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_timer_timeout():
	if not GlobalSceneScript.tutorial_complete:
		get_tree().change_scene_to(tutorial)
	else:
		get_tree().change_scene_to(game)

	pass # Replace with function body.
