extends Node2D

const NumberMinigame = preload("res://src/minigames/NumberMinigame.tscn")

@export var symbols = [] # (Array, Texture2D)

var number = 0

func _ready():
	if !Globals.has_completed_sheep:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[10]

func _on_InteractableCreature_entered():
	if Globals.has_completed_sheep:
		$InteractableCreature.symbol = symbols[10]
	else:
		randomize()
		number = randi() % 10
		$InteractableCreature.symbol = symbols[number]

func _on_InteractableCreature_interacted(body):
	if Globals.has_completed_sheep:
		return
	# 失败后按 Z 只换一个新数字并亮出来，再按一次才开始，免得新数字一闪而过。
	if $InteractableCreature.symbol == symbols[11]:
		randomize()
		number = randi() % 10
		$InteractableCreature.symbol = symbols[number]
		AudioManager.play_sfx("QuestionMarkAppears")
		return
	await get_tree().create_timer(0.25).timeout
	var minigame = NumberMinigame.instantiate()
	add_child(minigame)
	minigame.enemy_number = number
	minigame.clue_symbol = symbols[number]
	minigame.hint_level = Globals.sheep_misses + 1
	minigame.connect("won", Callable(self, "_on_Minigame_player_won"))
	minigame.connect("lost", Callable(self, "_on_Minigame_player_lost"))
	minigame.connect("canceled", Callable(self, "_on_Minigame_player_canceled"))

func _on_Minigame_player_won():
	Globals.has_completed_sheep = true
	AudioManager.play_main_music()
	Globals.open_barn_if_needed()
	$InteractableCreature.symbol = symbols[10]
	get_tree().call_group("barn_benches", "invite", "sheep", self, 1.5)

func _on_Minigame_player_lost():
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[11]
	AudioManager.play_sfx("FailedMinigame")
	AudioManager.play_sfx("SadFaceAppears")
	Globals.sheep_misses += 1

func _on_Minigame_player_canceled():
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[11]
	AudioManager.play_sfx("SadFaceAppears")
