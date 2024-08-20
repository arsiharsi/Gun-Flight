extends Node2D
# NODE VARS
export (NodePath) var quote_system
export (NodePath) var main_node
export (NodePath) var timer_node
export (NodePath) var camera_node
export (NodePath) var player_node

var player
var camera
var timer

var check_point = load("res://tscnes/others_and_stuff/check_point.tscn")
var target = load("res://tscnes/others_and_stuff/target.tscn")
# NODE VARS END
# SCRIPTED VARS
var joystick_check = false
# SCRIPTES VARS END
# LOADING NEW SCENE
var new_scene
var new_scene_path
func load_map():
	$front/screen/skip_tutorial.hide()
	$front/screen/loading.show()
	GlobalSceneScript.tutorial_complete = true
	GlobalSceneScript.saveFile()
	new_scene_path = "res://tscnes/menu/menu_1.tscn"
	new_scene = ResourceLoader.load_interactive("res://tscnes/menu/menu_1.tscn")

func update_progress():
	var progress = 100.0*float(new_scene.get_stage()) / new_scene.get_stage_count()
	get_node("front/screen/loading").value = progress
	pass
# LOADING NEW SCENE END
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var QArray = [["Oh, a new sufferer...", "Hope this one is special..."],["I don't need to know who you are...", "Tell me what's your side: left or right?"],
["That's it...", "Now, we begin our essential part...", "...part of you becoming a beter order executioner. Dealing with your weapon."],
["Didn't expect that...", " You are so light, even guns knockback pushes you...", "Use it as your advantage: navigate at high speeds!","Let's get to some targets as practice."],
["Incredible...","It's time for some aiming practice.", "Shoot all the targets."],
["Good! Very Good!", "Try other weapons as well"],
["Oh, Great!", "I think you are ready...", "To kill or be killed!"]]
var QColor = [[Color.red, Color.yellow],[Color.pink, Color.red],[Color.pink, Color.yellow, Color.red],[Color.pink, Color.yellow, Color.red, Color.red],
[Color.green, Color.yellow, Color.red],[Color.green, Color.green],[Color.green, Color.yellow, Color.red]]
var QSpeed = [[0.75, 0.5], [0.9, 0.4],[0.3, 0.5, 0.7],[0.3, 0.3, 1.0, 1.0],[0.3, 1, 1],[1,1],[1, 0.5, 1]]
var numQuote = 0
var numArray = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSceneScript.tutorial_complete = true
	randomize()
	if camera_node: camera = get_node(camera_node)
	if timer_node: timer = get_node(timer_node)
	if player_node: player = get_node(player_node)
	GlobalSceneScript.main_node = get_node_or_null(main_node)
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	pass # Replace with function body.

func _on_visibility_state_changed(state):
	# visible, hidden
	AudioServer.set_bus_volume_db(0, -72*int(state == "hidden"))


# QUOTES
func quotesF(num):
	match num:
		1:
			get_node(quote_system).hide()
			camera.first_object = camera.get_path_to(player)
			camera.second_object = camera.get_path_to(player)
			timer.start(1)
		2:
			get_node(quote_system).hide()
			$front/side_choosing.show()
		3:
			get_node(quote_system).hide()
			hints("HINT: Drag joystick to aim, drag joystick fully to shoot at desired direction.")
			joystick_check = true
		4:
			hints_hide()
			get_node(quote_system).hide()
			check_point_create()
		5:
			get_node(quote_system).hide()
			target_create()
		6:
			get_node(quote_system).hide()
			$center/weapons.position = Vector2.ZERO
			$animations/timer_for_quotes.start(10)
		7:
			get_node(quote_system).hide()
			$center/portal/gravity.gravity_point = true
			$center/portal/gravity/coll.set_deferred("disabled", false)
			$center/portal/portal_parts.emitting = true
			$animations/anims.play("ending")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if new_scene:
		var err = new_scene.poll()
		if err == ERR_FILE_EOF: # load finished
			var resource = new_scene.get_resource().instance()
			new_scene = null
			if GlobalSceneScript.is_pc_port:
				print("PC_PORT_CHANGE_SCENE")
				get_tree().change_scene(new_scene_path)
			else:
				get_node("/root").add_child(resource)
				self.queue_free()
		elif err == OK:
			update_progress()
	pass


func showQuote(text:String, color:Color, speed:float):
	if get_node_or_null(quote_system):
		var qs = get_node(quote_system)
		qs.show()
		qs.Qprint(text, color, speed)


func quoting(color: Color, speed: float):
	if numQuote == len(QArray[numArray]):
		numQuote = 0
		numArray += 1
		quotesF(numArray)
		return
	showQuote(QArray[numArray][numQuote], color, speed)
	numQuote += 1
	



func _on_nextQ_pressed():
	if quote_system:
		var qs = get_node(quote_system)
		if qs.isPrinting():
			qs.showAll()
		else:
#			quoting(QColor[clamp(numArray,0,len(QColor)-1)][clamp(numQuote,0,len(QColor[len(QColor)-1])-1)],
#			 QSpeed[clamp(numArray,0,len(QSpeed)-1)][clamp(numQuote,0,len(QSpeed[len(QSpeed)-1])-1)])
			quoting(QColor[clamp(numArray,0,len(QColor))][clamp(numQuote,0,len(QColor[numArray])-1)],
			QSpeed[clamp(numArray,0,len(QSpeed))][clamp(numQuote,0,len(QSpeed[numArray])-1)])
	pass # Replace with function body.


func _on_timer_for_quotes_timeout():
	_on_nextQ_pressed()
	pass # Replace with function body.



# QUOTES END
# HINTS
func hints(string):
	$front/hints.show()
	$front/hints.text = string
	pass

func hints_hide():
	$front/hints.hide()
# HINTS END

# SIDE CHOOSING
var side_choosed = false
func _on_right_side_choose_pressed():
	if !GlobalSceneScript.is_pc_port:
		$GUI/joystick_r.show()
		$GUI/joystick_l.hide()
	side_choosed = true
	pass # Replace with function body.


func _on_left_side_choose_pressed():
	if !GlobalSceneScript.is_pc_port:
		$GUI/joystick_r.hide()
		$GUI/joystick_l.show()
	side_choosed = true
	pass # Replace with function body.


func _on_final_choose_side_pressed():
	if side_choosed:
		_on_nextQ_pressed()
		$front/side_choosing.hide()
	pass # Replace with function body.

# SIDE CHOOSING END

# JOYSTICK CHECK
func _on_joystick_out(_direction, is_shooting):
	if is_shooting and joystick_check:
		_on_nextQ_pressed()
		joystick_check = false
	pass # Replace with function body.
# JOYSTICK CHECK END
# CHECK POINTS PART
var cps_count = -1

func check_point_create():
	cps_count += 1
	hints(str(cps_count) + "/10")
	if cps_count == 10:
		camera.second_object = camera.get_path_to(player)
		hints_hide()
		_on_nextQ_pressed()
		return
	var cp = check_point.instance()
	cp.global_position = Vector2(rand_range(100, 924), rand_range(100, 476))
	get_node(main_node).add_child(cp)
	cp.recieving_node = cp.get_path_to(self)
	cp.func_name = "check_point_create"
	camera.second_object = camera.get_path_to(cp)
# CHECK POINTS PART END
# TARGET PRACTICE
var targets_count = -1

func target_create():
	targets_count += 1
	hints(str(targets_count) + "/10")
	if targets_count == 10:
		camera.second_object = camera.get_path_to(player)
		hints_hide()
		_on_nextQ_pressed()
		return
	var trgt = target.instance()
	trgt.global_position = Vector2(rand_range(100, 924), rand_range(100, 476))
	get_node(main_node).add_child(trgt)
	trgt.recieving_node = trgt.get_path_to(self)
	trgt.func_name = "target_create"
	camera.second_object = camera.get_path_to(trgt)
# TARGET PRACTICE END
