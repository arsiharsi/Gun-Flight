extends Control


# Declare member variables here. Examples:
# var a = 2
# var b= "text"

export (NodePath) var Screen_To_Show_Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_pause_button_pressed():
	get_tree().paused = not get_tree().paused
	$cover.visible = get_tree().paused
	if get_node_or_null(Screen_To_Show_Node):
		get_node(Screen_To_Show_Node).visible = get_tree().paused
	pass # Replace with function body.
