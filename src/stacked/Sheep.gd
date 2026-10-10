extends Node2D

const NumberMinigame = preload("res://src/minigames/NumberMinigame.tscn")
const HintText = preload("res://src/ui/HintText.gd")

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
	# 失败后按 Z 只换一个新数字并展示出来，再按一次才开始，免得数字一闪而过。
	if $InteractableCreature.symbol == symbols[11]:
		randomize()
		number = randi() % 10
		$InteractableCreature.symbol = symbols[number]
		AudioManager.play_sfx("QuestionMarkAppears")
		TextBox.show_hint(HintText.SHEEP, $InteractableCreature)
		return
	await get_tree().create_timer(0.25).timeout
	TextBox.show_hint(HintText.NUMBER_CONTROLS, self, true)
	var minigame = NumberMinigame.instantiate()
	add_child(minigame)
	minigame.enemy_number = number
	minigame.connect("won", Callable(self, "_on_Minigame_player_won"))
	minigame.connect("lost", Callable(self, "_on_Minigame_player_lost"))
	minigame.connect("canceled", Callable(self, "_on_Minigame_player_canceled"))

func _on_Minigame_player_won():
	Globals.has_completed_sheep = true
	AudioManager.play_main_music()
	Globals.open_barn_if_needed()
	$InteractableCreature.symbol = symbols[10]
	finish_minigame_hint()

func _on_Minigame_player_lost():
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[11]
	AudioManager.play_sfx("FailedMinigame")
	AudioManager.play_sfx("SadFaceAppears")
	Globals.note_failure("sheep")
	finish_minigame_hint()

func _on_Minigame_player_canceled():
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[11]
	AudioManager.play_sfx("SadFaceAppears")
	finish_minigame_hint()

func finish_minigame_hint():
	TextBox.hide_hint(self)
	$InteractableCreature.refresh_hint()

func get_hint():
	if Globals.has_completed_sheep:
		return HintText.SHEEP_DONE
	if $InteractableCreature.symbol == symbols[11]:
		return HintText.SHEEP_RETRY
	return HintText.SHEEP
