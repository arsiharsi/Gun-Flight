extends RigidBody2D
var dir = Vector2.ZERO
export var inForce = 100.0
export (String, "corpse", "gib") var death = "corpse"
var player_shot = ""
var once = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_deferred("angular_velocity",rand_range(-45,45))
	call_deferred("apply_central_impulse", dir * inForce)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _integrate_forces(state):
	if state.get_contact_count() > 0:
		$hit.play()
		if  not once:
			$timeout.start()
			once = true
	pass

func bullet_hit():
	_on_timeout_timeout()

func _on_damager_and_booster_body_entered(body):
	if body.has_method("isCorpse"):
		body.call_deferred("isCorpse")
	if body.has_method("death"):
		if body.player != player_shot:
			body.death(death)
	pass # Replace with function body.


func _on_timeout_timeout():
	$damager_and_booster/coll.set_deferred("disabled", false)
	$damager_and_booster/coll/grav_timeout.start()
	$expl_part.emitting = true
	$expl.play()
	pass # Replace with function body.


func _on_expl_finished():
	queue_free()
	pass # Replace with function body.


func _on_coll_time_timeout():
	$coll.set_deferred("disabled",false)
	pass # Replace with function body.


func _on_grav_timeout_timeout():
	$sprite.hide()
	$damager_and_booster/coll.set_deferred("disabled", true)
	pass # Replace with function body.
