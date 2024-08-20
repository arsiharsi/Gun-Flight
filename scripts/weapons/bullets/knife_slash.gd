extends Sprite
var dir = Vector2.ZERO
var player_shot = ""
var rotation_speed:float
export var speed = 10.0
export (String, "corpse", "gib") var death = "corpse" 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = rand_range(-180,180)
	$anim.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.75, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	$anim.start()
	rotation_speed = deg2rad(rand_range(-45,45))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$damger.global_rotation = dir.angle()
	rotate(rotation_speed)
	position += dir * speed
	if $damger.is_colliding():
		if $damger.get_collider().has_method("isPlayer"):
			if $damger.get_collider().player != player_shot:
				$damger.get_collider().death(death)
				queue_free()
		if $damger.get_collider().has_method("bullet_hit"):
			$damger.get_collider().call_deferred("bullet_hit")
			queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_anim_tween_all_completed():
	queue_free()
	pass # Replace with function body.
