extends RigidBody2D
var corpse = load("res://tscnes/players/corpse.tscn")
var blood = load("res://tscnes/players/blood.tscn")
export (String, "blue", "red") var player = "blue"
export (NodePath) var camera_node 
var hand = {"blue":load("res://sprites/Anims/Blue/Hand.png"),"red":load("res://sprites/Anims/Red/Hand.png")}
export (String, "pistol", "uzi", "shotgun","m_gun","hand_granade","grenade_launcher", "bazooka", "laser", "f_thrower", "knife")var weapon = "pistol"
var shoot = false
var is_anim_stun = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	change_weapon()
	pass # Replace with function body.

func death(type):
	if GlobalSceneScript.main_node:
		GlobalSceneScript.main_node.call_deferred("player_death", self)
		$respawn.emitting = true
		$respawn.color = Color(int(player == "red"), 0 , int(player == "blue"))
		$respawn/resp_cd.start()
		if type == "corpse":
			var cor = corpse.instance()
			cor.global_position = global_position
			cor.player = player
			GlobalSceneScript.main_node.call_deferred("add_child", cor)
		elif type == "gib":
			var cor = blood.instance()
			cor.global_position = global_position
			GlobalSceneScript.main_node.call_deferred("add_child", cor)
	else:
		print("WARNING: Main node isn't set!")
	pass

func isPlayer():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $weapon/hand.texture != hand[player]:
		$weapon/hand.texture = hand[player]
	pass

func _integrate_forces(_state):
	animation(player)
	$weapon.look_at($direction.global_position)
	$weapon.scale.y = 1-2*int($weapon/hand.global_position.x < global_position.x)
	$sprite.flip_h = $direction.global_position.x < global_position.x
	if shoot:
		if $weapon/hand.get_child_count() > 0:
			$weapon/hand.get_child(0).shoot(player)
		shoot = false
	pass

func change_weapon():
	for i in range (0, $weapon/hand.get_child_count()):
		$weapon/hand.get_child(i).queue_free()
	$weapon/hand.add_child(load("res://tscnes/weapons/" + weapon + ".tscn").instance())
	pass


func _on_joystick(direction, is_shooting):
	$direction.position = direction
	shoot = is_shooting
	pass # Replace with function body.


func animation(color):
	if not is_anim_stun:
		if abs(linear_velocity.x) > 25:
			$sprite.play("speed_"+color)
			$sprite.speed_scale = abs(linear_velocity.x)/100
		else:
			$sprite.play("idle_"+color)
	else:
		$sprite.play("shot_"+color)
	pass


func anim_stun_func(time):
	is_anim_stun = true
	$anim_stun.start(time)

func _on_anim_stun_timeout():
	is_anim_stun = false
	pass # Replace with function body.




func _on_resp_cd_timeout():
	$respawn.emitting = false
	pass # Replace with function body.
