extends Area2D

export (String, "pistol", "uzi", "shotgun","m_gun","hand_granade","grenade_launcher", "bazooka", "laser", "f_thrower", "knife")var weapon = "pistol"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$spr.texture = load("res://tscnes/weapons/" + weapon + ".tscn").instance().texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_pickable_weapon_body_entered(body):
	if body.has_method("isPlayer"):
		body.weapon = weapon
		body.call_deferred("change_weapon")
	pass # Replace with function body.
