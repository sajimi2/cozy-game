extends Node2D

func _ready():
	hide_credits()
	$Node2D/Player.rotate_all_sprites(deg_to_rad(90.0))
	AudioManager.play_song("EndSceneMusic")

func is_showing_credits():
	return $CreditsLayer/Credits.visible

func hide_credits():
	AudioManager.play_sfx("CreditsHidden")
	$CreditsLayer/Credits.hide()
	$CreditsLayer/Paper.hide()

func show_credits():
	AudioManager.play_sfx("CreditsRevealed")
	$CreditsLayer/Credits.show()
	$CreditsLayer/Paper.show()

func is_any_movement_pressed():
	return Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or \
		Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")

func _process(delta):
	if (is_any_movement_pressed() or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel")) and is_showing_credits():
		await get_tree().create_timer(0.05).timeout
		hide_credits()
