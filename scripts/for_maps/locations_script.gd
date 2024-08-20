extends Node2D
export (String, "1v1", "pve") var game_type = "1v1"
export var is_Standard_Weapon_Order = true
export var weapon_order_ammount_to_change = 1
var s_weapons_order = ["pistol", "uzi", "shotgun",
"m_gun","hand_granade","grenade_launcher", "bazooka", "laser", "f_thrower", "knife"]
export (Array) var weapons_order = ["", "", "",
"","","", "", "", "", ""]
export (NodePath) var GUI_Node
export (NodePath) var player_1
var player_1_score = 0
var player_1_to_ch = 0 
export (NodePath) var player_2
var player_2_score = 0
var player_2_to_ch = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func player_death(player):
	if not GUI_Node:
		print("WARNING: GUI Node isn't set!")
	var GUI = get_node_or_null(GUI_Node)
	if get_node_or_null("spawns"):
		player.set_deferred("global_position",get_node("spawns").get_child(
			int(rand_range(0, get_node("spawns").get_child_count()))).global_position)
		if player == get_node_or_null(player_1):
			player_2_to_ch -= 1
			if player_2_to_ch <= 0:
				player_2_score += 1
				if player_2_score == len(weapons_order):
					GUI.call_deferred("win", get_node(player_1), 1, get_node(player_2))
				player_2_score = clamp(player_2_score,0, len(weapons_order)-1)
				if get_node_or_null(player_1):
					get_node(player_2).weapon = weapons_order[player_2_score]
					get_node(player_2).change_weapon()
				player_2_to_ch = weapon_order_ammount_to_change
				if GUI:
					GUI.value_changed(2)
		else:
			player_1_to_ch -= 1
			if player_1_to_ch <= 0:
				player_1_score += 1
				if player_1_score == len(weapons_order):
					GUI.call_deferred("win", get_node(player_2), 2, get_node(player_1))
				player_1_score = clamp(player_1_score,0, len(weapons_order)-1)
				if get_node_or_null(player_1):
					get_node(player_1).weapon = weapons_order[player_1_score]
					get_node(player_1).change_weapon()
				player_1_to_ch = weapon_order_ammount_to_change
				if GUI:
					GUI.value_changed(1)
	else:
		print("WARNING: Spawns aren't set!")



# Called when the node enters the scene tree for the first time.
func _ready():
	print(game_type)
	if game_type == "pve":
		$canvas/joystick1.side = GlobalSceneScript.one_pl_j_side
		if GlobalSceneScript.one_pl_j_side == "right":
			$canvas/joystick1.rect_position = $canvas/joystick2.rect_position
			$canvas/joystick1.start_pos = $canvas/joystick2.rect_position
	$vsbot_ai.set_active_ai(game_type == "pve")
	if !GlobalSceneScript.is_pc_port:
		$canvas/joystick2.visible = game_type != "pve"
	randomize()
	set_weapon_order()
	get_node(player_1).weapon = weapons_order[0]
	get_node(player_2).weapon = weapons_order[0]
	GlobalSceneScript.main_node = self
	player_1_to_ch = weapon_order_ammount_to_change
	get_node(player_1).change_weapon()
	player_2_to_ch = weapon_order_ammount_to_change
	get_node(player_2).change_weapon()
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	if GlobalSceneScript.is_pc_port:
		initialize()
	pass # Replace with function body.


func initialize():
	weapons_order = GlobalSceneScript.weapons_order
	is_Standard_Weapon_Order = GlobalSceneScript.is_Standard_Weapon_Order
	weapon_order_ammount_to_change = GlobalSceneScript.weapon_order_ammount_to_change
	game_type = GlobalSceneScript.game_type
	if game_type == "pve":
		$canvas/joystick1.side = GlobalSceneScript.one_pl_j_side
		if GlobalSceneScript.one_pl_j_side == "right":
			$canvas/joystick1.rect_position = $canvas/joystick2.rect_position
			$canvas/joystick1.start_pos = $canvas/joystick2.rect_position
	$vsbot_ai.set_active_ai(game_type == "pve")
	if !GlobalSceneScript.is_pc_port:
		$canvas/joystick2.visible = game_type != "pve"
	set_weapon_order()
	get_node(player_1).weapon = weapons_order[0]
	get_node(player_2).weapon = weapons_order[0]
	player_1_to_ch = weapon_order_ammount_to_change
	get_node(player_1).change_weapon()
	player_2_to_ch = weapon_order_ammount_to_change
	get_node(player_2).change_weapon()



func _on_visibility_state_changed(state):
	# visible, hidden
	AudioServer.set_bus_volume_db(0, -72*int(state == "hidden"))

func set_weapon_order():
	if is_Standard_Weapon_Order:
		weapons_order = s_weapons_order
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	gui_stuff()
	pass

func gui_stuff():
	var GUI = get_node_or_null(GUI_Node)
	if GUI:
		GUI.p1 = player_1_score
		GUI.p1_w = player_1_to_ch
		GUI.p2 = player_2_score
		GUI.p2_w = player_2_to_ch
