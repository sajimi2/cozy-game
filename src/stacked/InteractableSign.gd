extends Node2D

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

func _on_InteractableCreature_entered():
	pass # Replace with function body.
