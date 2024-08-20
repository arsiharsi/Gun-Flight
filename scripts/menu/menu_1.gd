extends Node2D
var once = false
var map_selected = "Random"
var map_path = ""
var pvp_maps_path = ["res://tscnes/locs/maps/1v1_coliseum.tscn", "res://tscnes/locs/maps/1v1_cruel_mountains.tscn", 
"res://tscnes/locs/maps/1v1_desert_standoff.tscn", "res://tscnes/locs/maps/1v1_paper_streer.tscn", "res://tscnes/locs/maps/1v1_panel_housing.tscn"]
var s_weapon_order = ["pistol", "uzi", "shotgun",
"m_gun","hand_granade","grenade_launcher", "bazooka", "laser", "f_thrower", "knife"]
var is_Standard_Weapon_Order = true
var weapons_order = ["pistol", "uzi", "shotgun",
"m_gun","hand_granade","grenade_launcher", "bazooka", "laser", "f_thrower", "knife"]
var weapon_order_ammount_to_change = 1
var game_type = "1v1"
var rand_diff = true
var change_weapon = 0
var new_scene
var start_pressed = false
export(NodePath) var ad_shower_node
var ad_shower
# Declare member variables here. Examples:
# var a = 2
# var b = "text"






# Called when the node enters the scene tree for the first time.
func _ready():
	ad_shower = get_node_or_null(ad_shower_node)
	GlobalSceneScript.load_from_bridge()
	Engine.time_scale = 1.0
	AudioServer.set_bus_layout(load("res://default_bus_layout.tres"))
	if GlobalSceneScript.loadSave():
		GlobalSceneScript.loadSave()
		$cl/l_side/settings/sound/mus_sett/slider.value = GlobalSceneScript.music_volume
		AudioServer.set_bus_volume_db(1, GlobalSceneScript.music_volume/100*80 - 80)
		$cl/l_side/settings/sound/sfx_sett/slider.value = GlobalSceneScript.sfx_volume
		AudioServer.set_bus_volume_db(2, GlobalSceneScript.sfx_volume/100*80 - 80)
		$cl/l_side/settings/game_1vAI/cs_change/lbl.text = GlobalSceneScript.one_pl_j_side.capitalize()
	randomize()
	$cl/central/buttons.position.y = get_viewport_rect().size.y
	$cl/r_side/settings.position.x = get_viewport_rect().size.x*2
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	pass # Replace with function body.

func _on_visibility_state_changed(state):
	# visible, hidden
	AudioServer.set_bus_volume_db(0, -72*int(state == "hidden" or ad_shower.last_state == "opened"))


func _process(_delta):
	get_node("cl/l_side/1v1/kills_to_change/spr/lbl_num").text = str(weapon_order_ammount_to_change)
	if new_scene:
		var err = new_scene.poll()
		if err == ERR_FILE_EOF: # load finished
			var resource = new_scene.get_resource().instance()
			if map_path != "res://tscnes/locs/tutorial.tscn":
				resource.weapons_order = weapons_order
				resource.is_Standard_Weapon_Order = is_Standard_Weapon_Order
				resource.weapon_order_ammount_to_change = weapon_order_ammount_to_change
				resource.game_type = game_type
			if GlobalSceneScript.is_pc_port:
				print("PC_PORT_CHANGE_SCENE")
				var resource_new = new_scene.get_resource()
				get_tree().change_scene_to(resource_new)
				if map_path != "res://tscnes/locs/tutorial.tscn":
					print(game_type)
					GlobalSceneScript.weapons_order = weapons_order
					GlobalSceneScript.is_Standard_Weapon_Order = is_Standard_Weapon_Order
					GlobalSceneScript.weapon_order_ammount_to_change = weapon_order_ammount_to_change
					GlobalSceneScript.game_type = game_type
			else:
				get_node("/root").add_child(resource)
				self.queue_free()
			new_scene = null
		elif err == OK:
			update_progress()
	get_node("cl/r_side/1v1/f_text/l").text = "map: "+ map_selected
	pass

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and not once:
		$cl/central/ttb.hide()
		$cl/central/buttons/t_anim.interpolate_property($cl/central/buttons, "position", 
		$cl/central/buttons.position, Vector2.ZERO, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$cl/central/buttons/t_anim.interpolate_property($cl/r_side/settings, "position", 
		$cl/r_side/settings.position, Vector2(0, 0),
		1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$cl/central/buttons/t_anim.start()
		once = true


func _on_1v1_pressed():
	game_type = "1v1"
	get_node("cl/central/buttons/1v1").hide()
	get_node("cl/central/buttons/1vAI").hide()
	get_node("cl/central/buttons/tutorial").hide()
	get_node("cl/l_side/1v1").show()
	get_node("cl/r_side/1v1").show()
	get_node("cl/central/buttons/1v1_start").show()
	get_node("cl/r_side/settings").hide()
	pass # Replace with function body.


func _on_1v1_back_pressed():
	get_node("cl/central/buttons/1v1").show()
	get_node("cl/central/buttons/1vAI").show()
	get_node("cl/central/buttons/tutorial").show()
	get_node("cl/l_side/1v1").hide()
	get_node("cl/r_side/1v1").hide()
	get_node("cl/central/buttons/1v1_start").hide()
	get_node("cl/r_side/settings").show()
	pass # Replace with function body.

func _on_1vAI_pressed():
	game_type = "pve"
	get_node("cl/central/buttons/1v1").hide()
	get_node("cl/central/buttons/1vAI").hide()
	get_node("cl/central/buttons/tutorial").hide()
	get_node("cl/l_side/1v1").show()
	get_node("cl/r_side/1v1").show()
	get_node("cl/central/buttons/1v1_start").show()
	get_node("cl/r_side/settings").hide()
	pass # Replace with function body.

func _on_sw_toggled(button_pressed):
	if button_pressed:
		get_node("cl/l_side/1v1/wch").hide()
		is_Standard_Weapon_Order = true
	else:
		get_node("cl/l_side/1v1/wch").show()
		is_Standard_Weapon_Order = false
	pass # Replace with function body.

func random_weapons(different):
	var order = [0,1,2,3,4,5,6,7,8,9]
	var new_order = []
	for _i in range(0, len(s_weapon_order)):
		var a = order[int(rand_range(0, len(order)))]
		new_order.append(s_weapon_order[a])
		if different:
			order.erase(a)
	weapons_order = new_order


func _on_different_weapons_toggled(button_pressed):
	rand_diff = button_pressed
	pass # Replace with function body.


func _on_randomize_pressed():
	random_weapons(rand_diff)
	pass # Replace with function body.


func _on_hide_weapons_toggled(button_pressed):
	get_node("cl/l_side/1v1/wch/hidden_box").visible = button_pressed
	pass # Replace with function body.


func _on_cancel_w_ch_pressed():
	get_node("cl/central/buttons/1v1_change_weapon/close_timer").start()
	pass # Replace with function body.


func on_change_weapon(id):
	weapons_order[change_weapon] = s_weapon_order[id]

func show_weap_change():
	get_node("cl/central/buttons/1v1_change_weapon").show()


func _on_close_w_ch_timer_timeout():
	get_node("cl/central/buttons/1v1_change_weapon").hide()
	pass # Replace with function body.


func _on_1v1_start_pressed():
	if not start_pressed:
		start_pressed = true
		if GlobalSceneScript.is_pc_port:
			ad_shower.show_ad()
		if map_selected == "Random":
			map_path = pvp_maps_path[int(rand_range(0,len(pvp_maps_path)))]
	get_node("cl/central/loading_screen/anim").play("def")
	
	pass # Replace with function body.

func load_map():
	new_scene = ResourceLoader.load_interactive(map_path)

func update_progress():
	var progress = 100.0*float(new_scene.get_stage()) / new_scene.get_stage_count()
	get_node("cl/central/loading_screen/pos_b_d/pb").value = progress
	pass


func _on_add_k_t_ch_pressed():
	weapon_order_ammount_to_change +=1
	weapon_order_ammount_to_change = clamp(weapon_order_ammount_to_change,1, 1000)
	pass # Replace with function body.


func _on_sub_k_t_ch_pressed():
	weapon_order_ammount_to_change -=1
	weapon_order_ammount_to_change = clamp(weapon_order_ammount_to_change,1, 1000)
	pass # Replace with function body.





func _on_settings_button_pressed():
	# INTERPOLATING ANIMATION
	$cl/r_side/settings/settings_anim.interpolate_property($cl/r_side/settings/sett_button, "position",
	$cl/r_side/settings/sett_button.position, Vector2(924, -30),
	1, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT,0)
	$cl/r_side/settings/settings_anim.interpolate_property($cl/r_side/settings/back_button, "position",
	$cl/r_side/settings/back_button.position, Vector2(1074-100, 25), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT,0)
	$cl/r_side/settings/settings_anim.interpolate_property($cl/l_side/settings, "position",
	$cl/l_side/settings.position, Vector2(0, 0), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT,0)
	# END
	$cl/r_side/settings/settings_anim.start()
	$cl/central/buttons.hide()
	pass # Replace with function body.


func _on_sett_back_button_pressed():
	# INTERPOLATING ANIMATION
	$cl/r_side/settings/settings_anim.interpolate_property($cl/r_side/settings/sett_button, "position",
	$cl/r_side/settings/sett_button.position, Vector2(924, 25),
	1, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT,0)
	$cl/r_side/settings/settings_anim.interpolate_property($cl/r_side/settings/back_button, "position",
	$cl/r_side/settings/back_button.position, Vector2(1074, 25), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT,0)
	$cl/r_side/settings/settings_anim.interpolate_property($cl/l_side/settings, "position",
	$cl/l_side/settings.position, Vector2(-215, 0), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT,0)
	# END
	$cl/r_side/settings/settings_anim.start()
	$cl/central/buttons.show()
	GlobalSceneScript.save_on_bridge()
	GlobalSceneScript.saveFile()
	pass # Replace with function body.


func _on_controll_side_change_pressed():
	if GlobalSceneScript.one_pl_j_side == "left":
		GlobalSceneScript.one_pl_j_side = "right"
	else:
		GlobalSceneScript.one_pl_j_side = "left"
	$cl/l_side/settings/game_1vAI/cs_change/lbl.text = GlobalSceneScript.one_pl_j_side.capitalize()
	pass # Replace with function body.


func _on_slider_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value/100*80 - 80)
	GlobalSceneScript.music_volume = value
	pass # Replace with function body.


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, value/100*80 - 80)
	GlobalSceneScript.sfx_volume = value
	pass # Replace with function body.


func _on_tutorial_pressed():
	map_path = "res://tscnes/locs/tutorial.tscn"
	get_node("cl/central/loading_screen/anim").play("def")
	pass # Replace with function body.



