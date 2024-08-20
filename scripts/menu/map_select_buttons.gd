extends TouchScreenButton
export var map = "Random"
export(String) var map_path
export (NodePath) var main_node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func pressed():
	if get_node_or_null(main_node):
		get_node(main_node).map_selected = map
		get_node(main_node).map_path = map_path
	pass # Replace with function body.
