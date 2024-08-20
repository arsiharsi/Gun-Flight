extends Sprite
export var stun_time = 0.1
export var feedback = 10000
export var timeout = 0.75
var able = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func shoot(player_shot):
	if player_shot and able:
		if get_node_or_null("shot"):
			get_node("shot").play()
		$attacks.play(str(int(rand_range(0, 5))))
		able = false
		$timer.start(timeout)
		get_node("../../..").call_deferred("anim_stun_func", stun_time)
		get_node("../../..").call_deferred("apply_central_impulse", 
		global_position.direction_to(get_node("../../..").global_position)*feedback)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $damager.is_colliding():
		if $damager.get_collider().has_method("isCorpse"):
			$damager.get_collider().call_deferred("isCorpse")
		if $damager.get_collider().has_method("isPlayer"):
			$damager.get_collider().call_deferred("death","gib")
	pass


func _on_timer_timeout():
	able = true
	pass # Replace with function body.
