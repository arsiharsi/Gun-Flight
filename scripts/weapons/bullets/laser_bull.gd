extends RayCast2D
var dir = Vector2.ZERO
var player_shot = ""
export (String, "corpse", "gib") var death = "corpse" 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = dir.angle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	cast_to = Vector2(get_viewport_rect().size.length()*GlobalSceneScript.zoom_screen,0)
	$length.cast_to = cast_to
	$sprite.region_rect = Rect2(0,0,cast_to.x,10)
	if $length.is_colliding():
		$sprite.region_rect = Rect2(0,0,($length.get_collision_point()-$sprite.global_position).length(),10)
	if is_colliding():
		if get_collider().has_method("isCorpse"):
			get_collider().call_deferred("isCorpse")
		if get_collider().has_method("isPlayer"):
			if get_collider().player != player_shot:
				get_collider().death(death)
	pass
