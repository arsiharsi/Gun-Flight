extends Control
export (NodePath) var changed_Value_Node
var p1 = 0
var p1_w = 1
var p2 = 0
var p2_w = 1

func win(player_lost, player_num_lost,player_won):
	if changed_Value_Node:
		get_node(changed_Value_Node).win(player_lost, player_num_lost,player_won)
	pass


func value_changed(player_digit):
	if changed_Value_Node:
		get_node(changed_Value_Node).changed_Value_Node(player_digit)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$p1_score.text = str(p1)
	$p2_score.text = str(p2)
	$p1_w.text = str(p1_w)
	$p2_w.text = str(p2_w)
	
	pass
