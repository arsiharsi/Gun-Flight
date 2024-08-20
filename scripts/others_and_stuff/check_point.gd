extends Area2D
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


func _on_check_point_body_entered(body):
	if body.has_method("isPlayer") and not checked:
		$parts.emitting = false
		$timer.start()
		checked = true
		if func_name and recieving_node:
			get_node(recieving_node).call_deferred(func_name)
	pass # Replace with function body.


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
