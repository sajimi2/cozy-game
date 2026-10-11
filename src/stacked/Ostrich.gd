extends Node2D

@export var symbols = [] # (Array, Texture2D)

func _ready():
	if Globals.barn_guests.has("ostrich"):
		queue_free()
		return
	if !Globals.has_completed_ostrich:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[1]

func _on_InteractableCreature_interacted(body):
	Globals.has_completed_ostrich = true
	AudioManager.play_main_music()
	$InteractableCreature.symbol = symbols[1]

func _on_InteractableCreature_entered():
	if $InteractableCreature.symbol == symbols[0]:
		AudioManager.play_sfx("QuestionMarkAppears")
