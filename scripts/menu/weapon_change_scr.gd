extends TouchScreenButton
export (NodePath) var menu_node
var w_names = ["Pistol", "Uzi", "Shotgun",
"Machine gun","Hand grenade","Grenade launcher", "Bazooka", "Laser riffle",
 "Flame thrower", "Knife"]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$spr/lbl.text = w_names[int(name)]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _pressed():
	if visible:
		if get_node_or_null(menu_node):
			get_node(menu_node).on_change_weapon(int(name))
			get_node(menu_node)._on_cancel_w_ch_pressed()
	pass # Replace with function body.



