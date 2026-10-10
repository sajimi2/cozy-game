extends Node2D

const RockPaperScissors = preload("res://src/minigames/RockPaperScissors.tscn")

@export var symbols = [] # (Array, Texture2D)

var can_interact = true

func _ready():
	if !Globals.has_completed_chicken:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[2]

func _on_InteractableCreature_interacted(body):
	if !can_interact or $InteractableCreature.symbol == symbols[2]:
		return
	if $InteractableCreature.symbol == symbols[1]:
		$InteractableCreature.symbol = symbols[0]
		$InteractableCreature/Interactable/Bubble/Symbol.frame = randi() % 4
	can_interact = false
	await get_tree().create_timer(0.25).timeout
	var minigame = RockPaperScissors.instantiate()
	add_child(minigame)
	var enemy_choice = min($InteractableCreature/Interactable/Bubble/Symbol.frame, 2)
	minigame.enemy_choice = enemy_choice
	minigame.connect("won", Callable(self, "_on_RPS_player_won"))
	minigame.connect("lost", Callable(self, "_on_RPS_player_lost"))
	minigame.connect("canceled", Callable(self, "_on_RPS_player_canceled"))

func _on_RPS_player_canceled():
	AudioManager.play_main_music()
	can_interact = true
	$InteractableCreature.symbol = symbols[0]

func _on_RPS_player_won():
	AudioManager.play_main_music()
	can_interact = true
	$InteractableCreature.symbol = symbols[1]
	AudioManager.play_sfx("FailedMinigame")
	AudioManager.play_sfx("SadFaceAppears")

func _on_RPS_player_lost():
	can_interact = true
	$InteractableCreature.symbol = symbols[2]
	Globals.has_completed_chicken = true
	AudioManager.play_main_music()
	Globals.open_barn_if_needed()
	get_tree().call_group("barn_benches", "invite", "chicken", self, 1.5)

func _on_InteractableCreature_exited():
	if $InteractableCreature.symbol == symbols[1]:
		$InteractableCreature.symbol = symbols[0]
