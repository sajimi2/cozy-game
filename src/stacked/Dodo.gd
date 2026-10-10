extends Node2D

@export var symbols = [] # (Array, Texture2D)

func _ready():
	if Globals.barn_guests.has("dodo"):
		queue_free()
		return
	if !Globals.has_completed_dodo:
		$InteractableCreature.symbol = symbols[0]
	else:
		$InteractableCreature.symbol = symbols[1]

func _on_InteractableCreature_interacted(body):
	if !Globals.has_completed_dodo and Globals.has_found_egg:
		AudioManager.play_sfx("DeliveredEgg")
		get_tree().call_group("west_area", "spawn_egg")
		Globals.has_completed_dodo = true
		AudioManager.play_main_music()
		$InteractableCreature.symbol = symbols[1]
	elif Globals.has_completed_dodo:
		$InteractableCreature.symbol = symbols[1]
	else:
		AudioManager.play_sfx("QuestionMarkAppears")
		$InteractableCreature.symbol = symbols[2]

func _on_InteractableCreature_exited():
	if $InteractableCreature.symbol == symbols[2]:
		$InteractableCreature.symbol = symbols[0]
