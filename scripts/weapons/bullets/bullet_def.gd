extends Sprite
var dir = Vector2.ZERO
var player_shot = ""
export var speed = 10.0
export (String, "corpse", "gib") var death = "corpse" 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position += dir * speed
	rotation = dir.angle()
	if $damger.is_colliding():
		if $damger.get_collider():
			if $damger.get_collider().has_method("isPlayer"):
				if $damger.get_collider().player != player_shot:
					$damger.get_collider().death(death)
			if $damger.get_collider().has_method("bullet_hit"):
				$damger.get_collider().call_deferred("bullet_hit")
			queue_free()
	pass
