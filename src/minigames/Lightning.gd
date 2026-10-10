extends Node2D

func _ready():
	var lightning_points = PackedVector2Array()
	for i in range(0, 8):
		var next_point = Vector2.ZERO
		if i % 2 == 0:
			next_point = Vector2(-14 + (i * 2) - randf_range(-2, 0), -160 + (i * 20) + randf_range(-8, 8))
		else:
			next_point = Vector2(14 + (i * 2) - randf_range(0, 2), -160 + (i * 20) + randf_range(-8, 8))
		lightning_points.push_back(next_point)
	lightning_points.push_back(Vector2.ZERO)
	$Lightning.points = lightning_points
	$AnimationPlayer.play("spawn")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.75).timeout
	$X.hide()
	get_tree().call_group("north_area", "flash_lightning")
	$Lightning.show()
	AudioManager.play_sfx("Lightning")
	await get_tree().create_timer(0.1).timeout
	$Lightning.hide()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	await get_tree().create_timer(0.05).timeout
	queue_free()

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		get_tree().call_group("north_area", "failed_minigame")
		get_tree().call_group("scarecrow", "failed_minigame")
