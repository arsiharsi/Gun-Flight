extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = str(GlobalSceneScript.tutorial_complete) + "\n"
	text = str(GlobalSceneScript.version) + "\n"
	text += str(GlobalSceneScript.one_pl_j_side) + "\n"
	text += str(GlobalSceneScript.music_volume) + "\n"
	text += str(GlobalSceneScript.sfx_volume) + "\n"
	pass
