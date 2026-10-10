extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

@export var symbols = [] # (Array, Texture2D)

func _ready():
	if Globals.has_completed_sign:
		$InteractableCreature.symbol = symbols[1]
	else:
		$InteractableCreature.symbol = symbols[0]

func _on_InteractableCreature_interacted(body):
	AudioManager.play_sfx("HeartAppears")
	if !Globals.has_completed_sign:
		$InteractableCreature.symbol = symbols[1]
		Globals.has_completed_sign = true
	$InteractableCreature.refresh_hint()

func _on_InteractableCreature_entered():
	pass # Replace with function body.

func get_hint():
	if Globals.has_completed_sign:
		return HintText.SIGN_DONE
	return HintText.SIGN
