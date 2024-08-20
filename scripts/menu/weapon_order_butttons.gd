extends TouchScreenButton
export (NodePath) var menu_node
var weapons = {"pistol": "Pistol", "uzi": "Uzi", "shotgun":"Shotgun",
"m_gun":"Machine gun","hand_granade":"Hand grenade","grenade_launcher":"Grenade launcher",
 "bazooka": "Bazooka", "laser": "Laser rifle", "f_thrower": "Flame thrower", "knife": "Knife"}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if menu_node:
		$spr/lbl.text = name +": "+ weapons[get_node(menu_node).weapons_order[int(name)-1]]
	pass


func _pressed():
	if menu_node:
		get_node(menu_node).change_weapon = int(name) - 1
		get_node(menu_node).show_weap_change()
	pass # Replace with function body.
