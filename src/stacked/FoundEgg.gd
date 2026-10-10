extends Node2D

@export var symbols = [] # (Array, Texture2D)

func _ready():
	$InteractableCreature.symbol = symbols[0]

func _on_InteractableCreature_interacted(body):
	pass
