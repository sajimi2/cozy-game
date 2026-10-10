extends Node2D

var progress_tween: Tween

const Lightning = preload("res://src/minigames/Lightning.tscn")

func _on_ToMainArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "NorthArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.MainArea)

func _ready():
	Globals.has_left_starting_area = true
	$Camera2D.offset = Vector2.ZERO
	$ProgressCover.hide()
	if Globals.last_scene_name == "MainArea":
		$Node2D/Player.position = Vector2(Globals.last_player_position.x, 276)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(0.0))

func start_timer():
	$ProgressCover.show()
	$ProgressCover/ProgressBar.value = 100
	if progress_tween:
		progress_tween.kill()
	progress_tween = create_tween()
	progress_tween.tween_property($ProgressCover/ProgressBar, "value", 0.0, 25.0).from(100.0)

func failed_minigame():
	$Node2D/FenceDoor.set_is_enabled(true)
	if progress_tween:
		progress_tween.kill()
	$ProgressCover.hide()
	$Node2D/FenceDoor.hide()
	$AnimationPlayer.play("reset_minigame")
	$Node2D/UnderRain.hide()
	$OverRain.hide()
	AudioManager.stop_all_ambient()
	for object in $Node2D.get_children():
		if "Spirit" in object.name or "Lightning" in object.name:
			object.queue_free()
	for lightning in $Lightnings.get_children():
		lightning.queue_free()

func won_minigame():
	failed_minigame()
	Globals.open_barn_if_needed()

func spawn_fence_door():
	$AnimationPlayer.play("spawn_fence_door")
	$Node2D/FenceDoor.set_is_enabled(false)
	$Node2D/UnderRain.show()
	$OverRain.show()
	AudioManager.play_ambient("Rain")

var last_spot = Vector2.ZERO
func spawn_lightning_bolt():
	var next_lightning = Lightning.instantiate()
	var next_spot = $LightningSpots.get_child(randi() % $LightningSpots.get_child_count()).position
	if randi() % 4 == 0:
		next_spot = Globals.current_player_position
	while next_spot.distance_to(last_spot) < 30 or next_spot.distance_to(Globals.current_player_position) > 75:
		next_spot = $LightningSpots.get_child(randi() % $LightningSpots.get_child_count()).position
	last_spot = next_spot
	$Lightnings.add_child(next_lightning)
	next_lightning.position = next_spot

func flash_lightning():
	$Cover.modulate.a = 0.5
	$AnimationPlayer.play("shake")
	await get_tree().create_timer(0.05).timeout
	$Cover.modulate.a = 1.0

func _on_MoveCameraUp_body_entered(body):
	if "Player" in body.name:
		$Camera2D.position = Vector2(94, 60)

func _on_MoveCameraDown_body_entered(body):
	if "Player" in body.name:
		$Camera2D.position = Vector2(94, 220)

func _on_ProgressBar_value_changed(value):
	if value == 0:
		get_tree().call_group("scarecrow", "won_minigame")
		won_minigame()
