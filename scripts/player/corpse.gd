extends RigidBody2D
var player = ""
var blood = load("res://tscnes/players/blood.tscn")
func isCorpse():
	if GlobalSceneScript:
		var cor = blood.instance()
		cor.global_position = global_position
		GlobalSceneScript.main_node.call_deferred("add_child", cor)
	queue_free()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _integrate_forces(_state):
	$sprite.play(player)
	if linear_velocity.length() != 0:
		$sprite.flip_h = linear_velocity.x < 0
