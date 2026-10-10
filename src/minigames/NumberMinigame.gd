extends CanvasLayer

var hand_tween: Tween

signal won
signal lost
signal canceled

var current_number = 0
var enemy_number = 0

var has_selected_number = false

func _ready():
	AudioManager.play_song("MinigameMusic")
	AudioManager.play_sfx("StartedMinigame")
	get_tree().paused = true
	$Question.frame = 0
	$Question/Shadow.frame = 0
	$Hand.frame = 0
	$Hand/Shadow.frame = 0
	move_hand_to_number(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_left") and !has_selected_number:
		current_number -= 1
		if current_number == -1:
			current_number = 9
		move_hand_to_number()
	if Input.is_action_just_pressed("ui_right") and !has_selected_number:
		current_number += 1
		if current_number == 10:
			current_number = 0
		move_hand_to_number()
	if Input.is_action_just_pressed("ui_accept") and $InputLagTimer.is_stopped() and !has_selected_number:
		has_selected_number = true
		AudioManager.play_sfx("SelectOptionUsingHand")
		for child in get_children():
			if "Number" in child.name and !str(current_number) in child.name:
				child.hide()
		$Hand.hide()
		await get_tree().create_timer(1.0).timeout
		$Question.hide()
		var enemy_number_object = find_child("Number_%s" % str(enemy_number)).duplicate()
		add_child(enemy_number_object)
		enemy_number_object.position = $Question.position
		enemy_number_object.show()
		var did_player_win = false
		if enemy_number == current_number:
			did_player_win = true
			AudioManager.play_sfx("RightAnswer")
			enemy_number_object.self_modulate = Color.GREEN.lightened(0.25)
		else:
			AudioManager.play_sfx("WrongAnswer")
			enemy_number_object.self_modulate = Color.RED.lightened(0.25)
		for i in range(0, 8):
			enemy_number_object.visible = !enemy_number_object.visible
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(1.5).timeout
		if did_player_win:
			emit_signal("won")
		else:
			emit_signal("lost")
		get_tree().paused = false
		queue_free()
	if Input.is_action_just_pressed("ui_cancel"):
		AudioManager.play_sfx("CanceledMinigame")
		emit_signal("canceled")
		get_tree().paused = false
		queue_free()

func move_hand_to_number(play_sound = true):
	if play_sound:
		AudioManager.play_sfx("ChangeOptionUsingHand")
	for child in get_children():
		if "Number" in child.name:
			child.self_modulate = Color.WHITE
	var number_ref = find_child("Number_%d" % current_number)
	number_ref.self_modulate = Color("e3d588")
	if hand_tween:
		hand_tween.kill()
	hand_tween = create_tween()
	hand_tween.tween_property($Hand, "position", number_ref.position - Vector2(0, 20), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _on_Hand_frame_changed():
	for child in get_children():
		if "Number" in child.name:
			child.frame = $Hand.frame
			child.get_child(0).frame = $Hand.frame

func _on_InputLagTimer_timeout():
	pass # Replace with function body.
