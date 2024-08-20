extends Position2D
var spread = 0.0
var bullet:PackedScene
var ammount = 1
var dir = Vector2.ZERO
var player_shot = ""
var inForce = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var bul = bullet.instance()
	bul.global_position = global_position
	bul.dir = dir
	bul.player_shot = player_shot
	if abs(inForce) != 0:
		bul.inForce = inForce
	if GlobalSceneScript.main_node:
		GlobalSceneScript.main_node.add_child(bul)
	else:
		print("WARNING:Main Node isn't set!")
	for _i in range(1, ammount):
		var b = bullet.instance()
		b.global_position = global_position
		b.dir = Vector2(dir.x+rand_range(-spread,spread), dir.y+rand_range(-spread,spread))
		b.player_shot = player_shot
		if abs(inForce) != 0:
			b.inForce = inForce
		if GlobalSceneScript.main_node:
			GlobalSceneScript.main_node.add_child(b)
		else:
			print("WARNING:Main Node isn't set!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
