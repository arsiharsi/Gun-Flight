extends Node
export (NodePath) var dyn_cam 
export (NodePath) var J1 
export (NodePath) var J2
export (NodePath) var lbl_won
var global_time_scale = 1.0
var new_scene
var new_scene_path
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func win(player_lost, player_num_lost,player_won):
	var dc = get_node(dyn_cam)
	dc.first_object = dc.get_path_to(player_won)
	dc.second_object = dc.get_path_to(player_won)
	player_lost.queue_free()
	if player_num_lost == 1: 
		get_node(J1).hide()
		get_node(lbl_won).text = "player 2 won!"
	else: 
		get_node(J2).hide()
		get_node(lbl_won).text = "player 1 won!"
	Engine.time_scale = 0.1
	$tmr.start()
	pass


func changed_Value_Node(p_digit):
	get_node("p"+str(p_digit)).play("def")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if new_scene:
		var err = new_scene.poll()
		if err == ERR_FILE_EOF: # load finished
			get_tree().paused = false
			var resource = new_scene.get_resource().instance()
			new_scene = null
			if GlobalSceneScript.is_pc_port:
				print("PC_PORT_CHANGE_SCENE")
				get_tree().change_scene(new_scene_path)
			else:
				get_node("/root").add_child(resource)
				GlobalSceneScript.main_node.queue_free()
		elif err == OK:
			update_progress()


func _on_tmr_timeout():
	Engine.time_scale = 1.0
	get_node(lbl_won).show()
	if get_node_or_null("../../../music"):
		get_node("../../../music").stream_paused = true
	pass # Replace with function body.

func update_progress():
	var progress = 100.0*float(new_scene.get_stage()) / new_scene.get_stage_count()
	get_node("../p_won/back/spr/back").text = str(progress)
	pass

func _on_back_pressed():
	if not new_scene:
		new_scene = ResourceLoader.load_interactive("res://tscnes/menu/menu_1.tscn")
		new_scene_path = "res://tscnes/menu/menu_1.tscn"
	pass # Replace with function body.
