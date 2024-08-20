extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var add_to_visibility = 0.0
export var speed = 1.0
var float_visible_chars = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$quote_place.visible_characters = float_visible_chars
	if float_visible_chars < $quote_place.text.length():
		float_visible_chars += speed
		$sound.play()
	pass




func Qprint(text:String, color:Color,inSpeed:float):
	$quote_place.text = text
	$quote_place.self_modulate = color
	$quote_place.visible_characters = 0
	float_visible_chars = 0
	speed = inSpeed


func isPrinting():
	return float_visible_chars < $quote_place.text.length()

func showAll():
	float_visible_chars = $quote_place.text.length()
