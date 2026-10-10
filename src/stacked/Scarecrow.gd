extends Node2D

const Spirit = preload("res://src/stacked/Spirit.tscn")
const TinySpirit = preload("res://src/stacked/TinySpirit.tscn")

@export var symbols = [] # (Array, Texture2D)

enum AttackType {
	SPREAD,
	FOLLOW,
	RANDOM
}

var player_ref = null
var attack_order = [AttackType.SPREAD, AttackType.FOLLOW, AttackType.RANDOM]
var attack_index = 0
var current_attack_type = AttackType.SPREAD
var has_failed_minigame = false
var is_in_minigame = false

func _ready():
	if Globals.barn_guests.has("scarecrow"):
		queue_free()
		return
	if !Globals.has_completed_scarecrow:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[4]

func _process(delta):
	if player_ref:
		$InteractableCreature.turn_towards(player_ref.global_position)
	if is_in_minigame and Input.is_action_just_pressed("ui_cancel"):
		AudioManager.play_sfx("CanceledMinigame")
		get_tree().call_group("north_area", "failed_minigame")
		get_tree().call_group("scarecrow", "failed_minigame")

func _on_InteractableCreature_interacted(body):
	if Globals.has_completed_scarecrow:
		$InteractableCreature.symbol = symbols[4]
		return
	AudioManager.play_song("MinigameMusic")
	AudioManager.play_sfx("StartedMinigame")
	has_failed_minigame = false
	player_ref = body
	player_ref.can_move = false
	get_tree().call_group("north_area", "spawn_fence_door")
	await get_tree().create_timer(0.75).timeout
	$InteractableCreature.arc_radius = 0
	$InteractableCreature.arc_collision_radius = 0
	$InteractableCreature.slow_turn_towards(body.global_position)
	set_battle_symbol(symbols[1])
	await get_tree().create_timer(2.0).timeout
	$Bubble.hide()
	player_ref.can_move = true
	get_tree().call_group("north_area", "start_timer")
	randomize()
	attack_order.shuffle()
	current_attack_type = attack_order[attack_index]
	is_in_minigame = true
	attack()

func attack():
	match current_attack_type:
		AttackType.SPREAD:
			spread_attack()
		AttackType.FOLLOW:
			follow_attack()
		AttackType.RANDOM:
			random_attack()

func won_minigame():
	Globals.has_completed_scarecrow = true
	AudioManager.play_main_music()
	player_ref.can_move = true
	is_in_minigame = false
	$InteractableCreature.arc_radius = 10
	$InteractableCreature.arc_collision_radius = 24
	player_ref = null
	$InteractableCreature.slow_turn_towards(global_position + Vector2(0, 8))
	await get_tree().create_timer(0.1).timeout
	set_battle_symbol(symbols[4])

func failed_minigame():
	if has_failed_minigame:
		return
	AudioManager.play_main_music()
	player_ref.can_move = true
	is_in_minigame = false
	$InteractableCreature.arc_radius = 10
	$InteractableCreature.arc_collision_radius = 24
	player_ref = null
	has_failed_minigame = true
	set_battle_symbol(symbols[3])
	AudioManager.play_sfx("FailedMinigame")
	AudioManager.play_sfx("SadFaceAppears")
	$InteractableCreature.slow_turn_towards(global_position + Vector2(0, -8))

func handle_post_attack():
	await get_tree().create_timer(2.0).timeout
	if has_failed_minigame or !is_in_minigame:
		return
	attack_index += 1
	if attack_index == 3:
		attack_index = 0
	current_attack_type = attack_order[attack_index]
	attack()

func random_attack():
	set_battle_symbol(symbols[6])
	await get_tree().create_timer(1.0).timeout
	for i in range(0, 10):
		if has_failed_minigame or !is_in_minigame:
			return
		get_tree().call_group("north_area", "spawn_lightning_bolt")
		await get_tree().create_timer(0.35).timeout
	hide_battle_symbol()
	handle_post_attack()

func spread_attack():
	set_battle_symbol(symbols[5])
	await get_tree().create_timer(1.0).timeout
	var random_start_offset = randi() % 45
	for i in range(0, 10):
		if has_failed_minigame or !is_in_minigame:
			return
		var current_angle = random_start_offset + (i * 8)
		while current_angle > 45:
			current_angle -= 45
		while current_angle < 360:
			var next_spirit = TinySpirit.instantiate()
			get_parent().add_child(next_spirit)
			next_spirit.global_position = global_position + Vector2(0, -4)
			next_spirit.direction = Vector2(sin(deg_to_rad(current_angle)), cos(deg_to_rad(current_angle)))
			current_angle += 45
		await get_tree().create_timer(0.25).timeout
	hide_battle_symbol()
	handle_post_attack()

func follow_attack():
	set_battle_symbol(symbols[2])
	await get_tree().create_timer(1.0).timeout
	if has_failed_minigame or !is_in_minigame:
		return
	for i in range(0, 8):
		if has_failed_minigame or !is_in_minigame:
			return
		var next_spirit = Spirit.instantiate()
		get_parent().add_child(next_spirit)
		next_spirit.global_position = global_position + Vector2(0, -8)
		await get_tree().create_timer(0.5).timeout
	hide_battle_symbol()
	handle_post_attack()

func hide_battle_symbol():
	$Bubble.hide()

func set_battle_symbol(symbol):
	$Bubble.show()
	$Bubble/Symbol.texture = symbol

func _on_Bubble_frame_changed():
	$Bubble/Symbol.frame = $Bubble.frame

func _on_InteractableCreature_entered():
	hide_battle_symbol()
	if !Globals.has_completed_scarecrow:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[4]
