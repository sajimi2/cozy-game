extends Node2D

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

func failed_minigame():
	AudioManager.stop_all_ambient()
	is_in_minigame = false
	AudioManager.play_sfx("FailedMinigame")
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[1]
	AudioManager.play_sfx("SadFaceAppears")
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
