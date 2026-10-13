extends Node2D

func _ready():
	hide_credits()
	$Node2D/Player.rotate_all_sprites(deg_to_rad(90.0))
	AudioManager.play_song("EndSceneMusic")

func is_showing_credits():
	return $EndingGallery.is_open()

func hide_credits():
	AudioManager.play_sfx("CreditsHidden")
	$CreditsLayer/Credits.hide()
	$CreditsLayer/Paper.hide()

func show_credits():
	AudioManager.play_sfx("CreditsRevealed")
	$EndingGallery.open()

func _on_ending_gallery_closed():
	$Node2D/Podium.rearm_page()
