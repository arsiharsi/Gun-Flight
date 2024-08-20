extends KinematicBody2D
var speed = 10.0
var dir = Vector2.ZERO
var player_shot = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player_shot = get_parent().player_shot
	speed = get_parent().speed
	dir = get_parent().dir
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
