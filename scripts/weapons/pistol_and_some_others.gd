extends Sprite
export var stun_time = 0.1
export var feedback = 10000
export var timeout = 0.75
export var isCluster = false
export var ClusterAmmount = 1
export var ClusterSpread = 0.0
export var isRigid = false
export var isRigidForce = 100.0
export (PackedScene) var bullet
var able = true
var cluster = load("res://tscnes/weapons/bullets/cluster_buls.tscn")

func shoot(player_shot):
	if able and bullet:
		if get_node_or_null("shot"):
			get_node("shot").play()
		if not isCluster: 
			var bul = bullet.instance()
			bul.global_position = $point.global_position
			bul.dir = get_node("../../..").global_position.direction_to(global_position)
			bul.player_shot = player_shot
			if isRigid:
				bul.inForce = isRigidForce
			if GlobalSceneScript.main_node:
				GlobalSceneScript.main_node.call_deferred("add_child",bul)
			else:
				print("WARNING:Main Node isn't set!")
			able = false
			$timer.start(timeout)
			get_node("../../..").call_deferred("anim_stun_func", stun_time)
			get_node("../../..").call_deferred("apply_central_impulse", 
			global_position.direction_to(get_node("../../..").global_position)*feedback)
		else:
			var cl = cluster.instance()
			cl.bullet = bullet
			cl.spread = ClusterSpread
			cl.ammount = ClusterAmmount
			cl.global_position = $point.global_position
			cl.dir = get_node("../../..").global_position.direction_to(global_position)
			cl.player_shot = player_shot
			if isRigid:
				cl.inForce = isRigidForce
			if GlobalSceneScript.main_node:
				GlobalSceneScript.main_node.call_deferred("add_child",cl)
			else:
				print("WARNING:Main Node isn't set!")
			able = false
			$timer.start(timeout)
			get_node("../../..").call_deferred("anim_stun_func", stun_time)
			get_node("../../..").call_deferred("apply_central_impulse", 
			global_position.direction_to(get_node("../../..").global_position)*feedback)


func _on_timer_timeout():
	able = true
	pass # Replace with function body.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
