extends Node2D

@export var starting_rotation: int = -135

func _ready():
	$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))
