extends CanvasLayer

var hand_tween: Tween

signal won
signal lost
signal canceled

enum Choice {
	ROCK, PAPER, SCISSORS
}

var enemy_choice = Choice.ROCK
var player_choice = Choice.ROCK

var scores = []

var can_select_option = false

func _ready():
	AudioManager.play_song("MinigameMusic")
	AudioManager.play_sfx("StartedMinigame")
	get_tree().paused = true
	$EnemyPaper.hide()
	$EnemyRock.hide()
	$EnemyScissors.hide()
	$Rock.frame = 0
	$Rock/Shadow.frame = 0
	$Paper.frame = 0
	$Paper/Shadow.frame = 0
	$Scissors.frame = 0
	$Scissors/Shadow.frame = 0
	$Hand.frame = 0
	$Hand/Shadow.frame = 0
	$Question.frame = 0
	$Question/Shadow.frame = 0
	$Player.frame = 0
	$Chicken.frame = 0
	$Score.frame = 0
	$Redo.frame = 0
	$Score.hide()
	move_hand_to_choice(player_choice, false)
	can_select_option = true

func _process(delta):
	if Input.is_action_just_pressed("ui_right") and can_select_option:
		if player_choice == Choice.SCISSORS:
			return
		player_choice += 1
		move_hand_to_choice(player_choice)
	if Input.is_action_just_pressed("ui_left") and can_select_option:
		if player_choice == Choice.ROCK:
			return
		player_choice -= 1
		move_hand_to_choice(player_choice)
	if Input.is_action_just_pressed("ui_accept") and can_select_option and $InitialSelectTimer.is_stopped():
		AudioManager.play_sfx("SelectOptionUsingHand")
		show_selections()
		can_select_option = false
	if Input.is_action_just_pressed("ui_cancel"):
		AudioManager.play_sfx("CanceledMinigame")
		get_tree().paused = false
		emit_signal("canceled")
		queue_free()

func show_selections():
	$Hand.hide()
	$Question.hide()
	var enemy_choice_ref = null
	match enemy_choice:
		Choice.ROCK:
			enemy_choice_ref = $EnemyRock
			$EnemyRock.position = $Question.position
			$EnemyRock.show()
		Choice.PAPER:
			enemy_choice_ref = $EnemyPaper
			$EnemyPaper.position = $Question.position
			$EnemyPaper.show()
		Choice.SCISSORS:
			enemy_choice_ref = $EnemyScissors
			$EnemyScissors.position = $Question.position
			$EnemyScissors.show()
	var player_choice_ref = null
	match player_choice:
		Choice.ROCK:
			player_choice_ref = $Rock
			$Scissors.hide()
			$Paper.hide()
		Choice.PAPER:
			player_choice_ref = $Paper
			$Scissors.hide()
			$Rock.hide()
		Choice.SCISSORS:
			player_choice_ref = $Scissors
			$Rock.hide()
			$Paper.hide()
	var did_player_win = false
	var did_enemy_win = false
	if player_choice == Choice.ROCK and enemy_choice == Choice.SCISSORS:
		enemy_choice_ref.z_index = 1
		did_player_win = true
	if player_choice == Choice.PAPER and enemy_choice == Choice.ROCK:
		enemy_choice_ref.z_index = 1
		did_player_win = true
	if player_choice == Choice.SCISSORS and enemy_choice == Choice.PAPER:
		enemy_choice_ref.z_index = 1
		did_player_win = true
	if player_choice == Choice.ROCK and enemy_choice == Choice.PAPER:
		player_choice_ref.z_index = 1
		did_enemy_win = true
	if player_choice == Choice.PAPER and enemy_choice == Choice.SCISSORS:
		player_choice_ref.z_index = 1
		did_enemy_win = true
	if player_choice == Choice.SCISSORS and enemy_choice == Choice.ROCK:
		player_choice_ref.z_index = 1
		did_enemy_win = true
	await get_tree().create_timer(0.5).timeout
	var choice_tween := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	choice_tween.tween_property(player_choice_ref, "position", $Center.position, 0.75)
	choice_tween.tween_property(enemy_choice_ref, "position", $Center.position, 0.75)
	await choice_tween.finished
	if !did_enemy_win and !did_player_win:
		enemy_choice_ref.hide()
	await get_tree().create_timer(0.375).timeout
	
	if player_choice == Choice.ROCK and enemy_choice == Choice.SCISSORS:
		AudioManager.play_sfx("RockBeatScissors")
	if player_choice == Choice.PAPER and enemy_choice == Choice.ROCK:
		AudioManager.play_sfx("PaperBeatRock")
	if player_choice == Choice.SCISSORS and enemy_choice == Choice.PAPER:
		AudioManager.play_sfx("ScissorsBeatPaper")
	if player_choice == Choice.ROCK and enemy_choice == Choice.PAPER:
		AudioManager.play_sfx("PaperBeatRock")
	if player_choice == Choice.PAPER and enemy_choice == Choice.SCISSORS:
		AudioManager.play_sfx("ScissorsBeatPaper")
	if player_choice == Choice.SCISSORS and enemy_choice == Choice.ROCK:
		AudioManager.play_sfx("RockBeatScissors")
	
	if did_enemy_win:
		$AnimationPlayer.play("fade_players_choice")
		await $AnimationPlayer.animation_finished
	elif did_player_win:
		$AnimationPlayer.play("fade_enemy_choice")
		await $AnimationPlayer.animation_finished
	
	await get_tree().create_timer(1.125).timeout
	enemy_choice_ref.hide()
	player_choice_ref.hide()
	var icon_ref = null
	if did_player_win:
		var next_icon = $Player.duplicate()
		$Score.add_child(next_icon)
		next_icon.position = Vector2(-32 + (len(scores) * 32), 0)
		scores.push_back(1)
		icon_ref = next_icon
	elif did_enemy_win:
		var next_icon = $Chicken.duplicate()
		$Score.add_child(next_icon)
		next_icon.position = Vector2(-32 + (len(scores) * 32), 0)
		scores.push_back(-1)
		icon_ref = next_icon
	else:
		var next_icon = $Redo.duplicate()
		$Score.add_child(next_icon)
		next_icon.position = Vector2(-32 + (len(scores) * 32), 0)
		icon_ref = next_icon
	icon_ref.hide()
	$Score.show()
	$AnimationPlayer.play("fade_in_score")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(.1).timeout
	if did_player_win:
		AudioManager.play_sfx("YouWonRound")
	elif did_enemy_win:
		AudioManager.play_sfx("EnemyWonRound")
	else:
		AudioManager.play_sfx("TiedRound")
	for i in range(0, 7):
		icon_ref.visible = !icon_ref.visible
		await get_tree().create_timer(.085).timeout
	await get_tree().create_timer(1.0).timeout
	
	if did_player_win():
		await get_tree().create_timer(0.5).timeout
		AudioManager.play_sfx("YouWonEntireMatch")
		for i in range(0, 8):
			for child in $Score.get_children():
				if "Player" in child.name:
					child.visible = !icon_ref.visible
			await get_tree().create_timer(.085).timeout
		await get_tree().create_timer(0.75).timeout
	elif did_enemy_win():
		await get_tree().create_timer(1.0).timeout
		AudioManager.play_sfx("EnemyWonEntireMatch")
		for i in range(0, 8):
			for child in $Score.get_children():
				if "Chicken" in child.name:
					child.visible = !icon_ref.visible
			await get_tree().create_timer(.085).timeout
		await get_tree().create_timer(0.75).timeout
	
	$AnimationPlayer.play("fade_out_score")
	await $AnimationPlayer.animation_finished
	$Score.hide()
	for child in $Score.get_children():
		if "Redo" in child.name:
			child.queue_free()
	await get_tree().create_timer(.25).timeout
	
	if did_player_win():
		emit_signal("won")
		get_tree().paused = false
		queue_free()
	elif did_enemy_win():
		emit_signal("lost")
		get_tree().paused = false
		queue_free()
	else:
		reset_board()

func did_player_win():
	var player_won_count = 0
	for score in scores:
		if score == 1:
			player_won_count += 1
	return player_won_count >= 2

func did_enemy_win():
	var enemy_won_count = 0
	for score in scores:
		if score == -1:
			enemy_won_count += 1
	return enemy_won_count >= 2

func reset_board():
	for child in get_children():
		if child is AnimatedSprite2D:
			child.z_index = 0
	$AnimationPlayer.play("fade_in_all_choices")
	await get_tree().create_timer(0.05).timeout
	$Rock.position = Vector2(42, 116)
	$Paper.position = Vector2(96, 116)
	$Scissors.position = Vector2(150, 116)
	$Question.show()
	$Rock.show()
	$Paper.show()
	$Scissors.show()
	player_choice = Choice.ROCK
	$Hand.show()
	$Hand.position = Vector2(42, 84)
	move_hand_to_choice(player_choice)
	can_select_option = true

func move_hand_to_choice(next_choice, play_sound = true):
	if play_sound:
		AudioManager.play_sfx("ChangeOptionUsingHand")
	var next_position = Vector2.ZERO
	match next_choice:
		Choice.ROCK:
			next_position = $Rock.position + Vector2(0, -32)
		Choice.PAPER:
			next_position = $Paper.position + Vector2(0, -32)
		Choice.SCISSORS:
			next_position = $Scissors.position + Vector2(0, -32)
	if hand_tween:
		hand_tween.kill()
	hand_tween = create_tween()
	hand_tween.tween_property($Hand, "position", next_position, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _on_InitialSelectTimer_timeout():
	pass # Replace with function body.
