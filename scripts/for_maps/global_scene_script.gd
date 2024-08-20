extends Node
var is_pc_port = false
var main_node
var zoom_screen = 0.0
var one_pl_j_side = "left"
var tutorial_complete = false
var version = 2
var music_volume = 100
var sfx_volume = 100
var game_save = preload("res://scripts/others_and_stuff/saveScr.gd")
var save_path = "user://save_GuFl.res"

var is_Standard_Weapon_Order = true
var weapons_order = ["pistol", "uzi", "shotgun",
"m_gun","hand_granade","grenade_launcher", "bazooka", "laser", "f_thrower", "knife"]
var weapon_order_ammount_to_change = 1
var game_type = "1v1"



func _on_storage_set_completed(success):
	print("On Storage Set Completed, success: ", success)


# Сохранить данные по нескольким ключам
func save_on_bridge():
	Bridge.storage.set(["music_volume", "sfx_volume", "one_pl_j_side", "tutorial_complete"], [str(music_volume), str(sfx_volume), one_pl_j_side, str(tutorial_complete)], funcref(self, "_on_storage_set_completed"))
#var callback_ad = JavaScript.create_callback(self, '_ad')
#onready var win = JavaScript.get_interface("window")



func load_from_bridge():
	print("Load from bridge")
	if Bridge.storage.is_supported("platform_internal"):
		Bridge.storage.get(["music_volume", "sfx_volume", "one_pl_j_side", "tutorial_complete"], funcref(self, "_on_storage_get_completed"))



func _on_storage_get_completed(success, data):
	if success:
		if data[0] != null:
			print("music_volume: ", data[0])
		else:
			print("music_volume is null")
		if data[1] != null:
			print("sfx_volume: ", data[1])
		else:
			print("sfx_volume is null")
		if data[2] != null:
			print("one_pl_j_side: ", data[2])
		else:
			print("one_pl_j_side is null")
		if data[3] != null:
			print("tutorial_complete: ", data[3])
		else:
			print("tutorial_complete is null")
		music_volume = int(data[0])
		sfx_volume = int(data[1])
		one_pl_j_side = data[2]
		tutorial_complete =bool(data[3])
#func _ad(args):
#	#AudioServer.set_stream_global_volume_scale(1)
#	print(args[0])
#
#func js_show_ad():
#	#AudioServer.set_stream_global_volume_scale(0)
#	#win.ShowAd(callback_ad)
#	pass
## Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func loadSave():
	var ada = Directory.new()
	if not ada.file_exists(save_path):
		return false
	var loa = load(save_path)
	music_volume = loa.music_volume
	sfx_volume = loa.sfx_volume
	one_pl_j_side = loa.one_pl_j_side
	if loa.version >= 2:
		tutorial_complete = loa.tutorial_complete
	return true
	pass

func saveFile():
	var new_save = game_save.new()
	new_save.version = version
	new_save.music_volume = music_volume
	new_save.sfx_volume = sfx_volume
	new_save.one_pl_j_side = one_pl_j_side
	new_save.tutorial_complete = tutorial_complete
	ResourceSaver.save(save_path,new_save)
	pass
