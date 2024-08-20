extends RigidBody2D

var checked = false
export (NodePath) var recieving_node
export (String) var func_name
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func bullet_hit():
	if recieving_node and func_name and not checked:
		get_node(recieving_node).call_deferred(func_name)
		checked = true
		$sound.play()
		$coll.set_deferred("disabled", true)
		$spr.hide()


func _on_sound_finished():
	queue_free()
	pass # Replace with function body.
