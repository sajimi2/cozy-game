extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

@export var symbols = [] # (Array, Texture2D)

func _ready():
	if !Globals.has_completed_ostrich:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[1]

func _on_InteractableCreature_interacted(body):
	Globals.has_completed_ostrich = true
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[1]
	$InteractableCreature.refresh_hint()

func _on_InteractableCreature_entered():
	if $InteractableCreature.symbol == symbols[0]:
		AudioManager.play_sfx("QuestionMarkAppears")

func get_hint():
	if Globals.has_completed_ostrich:
		return HintText.OSTRICH_DONE
	return HintText.OSTRICH
