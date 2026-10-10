extends Node

const StartingArea = "res://src/areas/StartingArea.tscn"
const MainArea = "res://src/areas/MainArea.tscn"
const WestArea = "res://src/areas/WestArea.tscn"
const NorthArea = "res://src/areas/NorthArea.tscn"
const EastArea = "res://src/areas/EastArea.tscn"
const BarnArea = "res://src/areas/BarnArea.tscn"

var current_player_position = Vector2.ZERO
var last_player_position = Vector2.ZERO
var last_scene_name = ""

var has_left_starting_area = false

var has_completed_sign = false
var has_completed_chicken = false
var has_completed_frog = false
var has_completed_scarecrow = false
var has_completed_sheep = false
var has_completed_ostrich = false
var has_completed_dodo = false

var has_found_egg = false

# 已经来到谷仓门前坐下的朋友，按到达顺序排列。
var barn_guests = []

var wind = Vector2.ZERO

enum BusType {
	SFX,
	MUSIC,
	MASTER
}

func get_progress_level():
	var progress = 0
	if has_completed_chicken:
		progress += 1
	if has_completed_frog:
		progress += 1
	if has_completed_scarecrow:
		progress += 1
	if has_completed_sheep:
		progress += 1
	if has_completed_ostrich:
		progress += 1
	if has_completed_dodo:
		progress += 1
	return progress

func has_completed(friend):
	return get("has_completed_" + friend)

func open_barn_if_needed():
	if get_progress_level() == 6:
		get_tree().call_group("barn", "open_barn")

func _process(delta):
	if OS.is_debug_build() and Input.is_action_just_pressed("ui_reset"):
		var current_scene_path = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file(current_scene_path)
	if Input.is_action_just_pressed("ui_screenshot") and OS.is_debug_build():
		var image = get_viewport().get_texture().get_image()
		image.save_png("user://Game_Screenshot_%s.png" % str(randi() % 1000))
