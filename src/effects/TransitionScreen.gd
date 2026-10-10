extends CanvasLayer

var next_scene = null
var master_volume = 0.0:
	set(value):
		master_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

var use_volume_tweening = false

func transition_scene_to(scene):
	if use_volume_tweening and OS.get_name() == "Web":
		create_tween().tween_property(self, "master_volume", -80.0, 0.05).from(0.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	$AnimationPlayer.play("fade_to_black")
	next_scene = scene

func slow_transition_scene_to(scene):
	$AnimationPlayer.play("slow_fade_to_black")
	next_scene = scene

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		get_tree().change_scene_to_file(next_scene)
		if use_volume_tweening and OS.get_name() == "Web":
			create_tween().tween_property(self, "master_volume", 0.0, 0.05).from(-80.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "slow_fade_to_black":
		get_tree().change_scene_to_file(next_scene)
		$AnimationPlayer.play("slow_fade_to_normal")

