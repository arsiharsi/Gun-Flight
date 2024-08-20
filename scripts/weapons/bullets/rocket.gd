extends RigidBody2D
export var inForce = 100.0
export (String, "corpse", "gib") var death = "corpse"
var dir = Vector2()
var player_shot = ""
var isActivated = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = dir.angle()
	pass # Replace with function body.

func bullet_hit():
	_on_expl_timer_timeout()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	if state.get_contact_count() > 0:
		$hit.play()
		if not isActivated:
			$expl_timer.start()
			isActivated = true
	apply_central_impulse(global_position.direction_to($direction.global_position)*inForce)
	pass


func _on_spawn_timer_timeout():
	$coll.set_deferred("disabled", false)
	pass # Replace with function body.


func _on_expl_timer_timeout():
	$damager_and_booster/coll.set_deferred("disabled", false)
	$damager_and_booster/coll/expl_part.emitting = true
	$damager_and_booster/coll/expl.play()
	$damager_and_booster/coll/grav_timeout.start()
	$animation.hide()
	pass # Replace with function body.


func _on_grav_timeout_timeout():
	$damager_and_booster/coll.set_deferred("disabled", true)
	pass # Replace with function body.


func _on_expl_finished():
	queue_free()
	pass # Replace with function body.


func _on_damager_and_booster_body_entered(body):
	if body.has_method("isCorpse"):
		body.call_deferred("isCorpse")
	if body.has_method("isPlayer"):
		if body.player != player_shot:
			body.call_deferred("death", death)
	pass # Replace with function body.
