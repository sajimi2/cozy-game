extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

@export var symbols = [] # (Array, Texture2D)

var is_showing_progress = false

func _ready():
	$InteractableCreature.symbol = symbols[7]

func _on_InteractableCreature_interacted(body):
	$InteractableCreature.symbol = symbols[Globals.get_progress_level()]
	AudioManager.play_sfx("SignShowsProgressHeart")
	is_showing_progress = true
	$InteractableCreature.refresh_hint()

func _on_InteractableCreature_exited():
	is_showing_progress = false
	$InteractableCreature.symbol = symbols[7]

func _on_InteractableCreature_entered():
	AudioManager.play_sfx("QuestionMarkAppears")

func get_hint():
	if is_showing_progress:
		return HintText.progress_text()
	return HintText.PROGRESS_SIGN
