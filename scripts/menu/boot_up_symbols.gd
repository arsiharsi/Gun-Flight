extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start_pos
var start_rotation 
var start_modulation
# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	start_rotation = rotation
	start_modulation = self_modulate
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position += (start_pos - position)/10
	rotation += (start_rotation - rotation)/10
	self_modulate += (start_modulation - self_modulate)/10
	pass
