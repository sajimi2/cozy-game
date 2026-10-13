extends Control

var _starting := false

func _ready() -> void:
	IllustratedDisplay.use_illustration(get_window())
	AudioManager.play_song("MainMusic_1")
	$Start.grab_focus()
	_update_sound_label()

func _on_sound_pressed() -> void:
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	_update_sound_label()

func _update_sound_label() -> void:
	$Sound.text = "声音：关" if AudioServer.is_bus_mute(0) else "声音：开"

func _on_start_pressed() -> void:
	if _starting:
		return
	_starting = true
	$Start.disabled = true
	AudioManager.stop_all_songs()
	# 等确认键松开再进场，防止同一次按键穿透到场景交互。
	while Input.is_action_pressed("ui_accept"):
		await get_tree().process_frame
	IllustratedDisplay.use_game(get_window())
	get_tree().change_scene_to_file(Globals.StartingArea)
