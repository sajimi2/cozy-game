extends Node2D

@export var symbols = [] # (Array, Texture2D)

var showed_credits = false

func _ready():
	$InteractableCreature.symbol = symbols[0]

func _on_InteractableCreature_interacted(body):
	if showed_credits:
		return
	get_tree().call_group("barn_area", "show_credits")
	showed_credits = true
	$InteractableCreature.symbol = symbols[1] 

func _on_InteractableCreature_exited():
	$InteractableCreature.symbol = symbols[0]
	showed_credits = false
