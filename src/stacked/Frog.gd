extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

@export var symbols = [] # (Array, Texture2D)
@export var frames = [] # (Array, Texture2D)

var player_ref = null

var is_in_minigame = false

func _ready():
	if !Globals.has_completed_frog:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[2]

func _on_InteractableCreature_interacted(body):
	if ($InteractableCreature.symbol == symbols[1] or $InteractableCreature.symbol == symbols[0]) and !is_in_minigame:
		if $InteractableCreature.symbol == symbols[1]:
			$InteractableCreature.symbol = symbols[0]
		is_in_minigame = true
		player_ref = body
		body.can_move = false
		get_tree().call_group("wind_generator", "stop_wind")
		get_tree().call_group("drone", "set_can_move", true)
		AudioManager.play_sfx("StartedMinigame")
		AudioManager.play_song("MinigameMusic")
		TextBox.show_hint(HintText.DRONE_CONTROLS, self, true, 6.0)

func failed_minigame():
	AudioManager.stop_all_ambient()
	is_in_minigame = false
	AudioManager.play_sfx("FailedMinigame")
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[1]
	AudioManager.play_sfx("SadFaceAppears")
	Globals.note_failure("frog")
	finish_minigame_hint()
	$InteractableCreature.turn_towards(player_ref.global_position)
	player_ref.turn_towards(global_position)
	await get_tree().create_timer(0.5).timeout
	get_tree().call_group("west_area", "spawn_drone")
	player_ref.can_move = true

func won_minigame():
	AudioManager.stop_all_ambient()
	is_in_minigame = false
	AudioManager.play_sfx("Landed")
	Globals.has_completed_frog = true
	AudioManager.play_main_music()
	Globals.open_barn_if_needed()
	$InteractableCreature.symbol = symbols[2]
	finish_minigame_hint()
	$InteractableCreature.turn_towards(player_ref.global_position)
	player_ref.turn_towards(global_position)
	await get_tree().create_timer(0.5).timeout
	player_ref.can_move = true

func _on_InteractableCreature_entered():
	if $InteractableCreature.symbol == symbols[1]:
		$InteractableCreature.symbol = symbols[0]

var current_frame = 0
func _on_Timer_timeout():
	current_frame = 1 if current_frame == 0 else 0
	$InteractableCreature.texture = frames[current_frame]

func finish_minigame_hint():
	TextBox.hide_hint(self)
	$InteractableCreature.refresh_hint()

func get_hint():
	if Globals.has_completed_frog:
		return HintText.FROG_DONE
	if is_in_minigame:
		return HintText.DRONE_CONTROLS
	if Globals.has_failed("frog"):
		return HintText.FROG_RETRY
	return HintText.FROG
