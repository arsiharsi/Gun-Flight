extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("show_values"):
		visible = not visible
	text = "VALUES: \nMUSIC = " + str(GlobalSceneScript.music_volume)
	text += "\nSFX = " + str(GlobalSceneScript.sfx_volume)
	text += "\nSIDE = " + str(GlobalSceneScript.one_pl_j_side)
	text += "\nTUTORIAL = " + str(GlobalSceneScript.tutorial_complete)
	pass
