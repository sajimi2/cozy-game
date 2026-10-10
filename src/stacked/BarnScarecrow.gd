extends Node2D

const Heart = preload("res://sprites/ui/symbols/Heart.png")

func _ready():
	$InteractableCreature.symbol = Heart
