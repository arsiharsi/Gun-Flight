extends Sprite
var slice = load("res://sprites/menu/bootsplash/slice.png")
var shoots = [load("res://sounds_and_music/weapons/pistol_shot.wav"),
load("res://sounds_and_music/weapons/m_gun_shot.wav"),
load("res://sounds_and_music/weapons/shotgun_shot.wav"), 
load("res://sounds_and_music/weapons/uzi_shot.wav"),
load("res://sounds_and_music/weapons/knife_slash.wav")]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var a = rand_range(0, len(shoots))
	$shoot_sound.stream = shoots[a]
	if $shoot_sound.stream == shoots[len(shoots)-1]:
		texture = slice
	$shoot_sound.play()
	rotation_degrees += rand_range(-180,180)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_shoot_sound_finished():
	queue_free()
	pass # Replace with function body.
