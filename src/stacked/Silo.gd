extends Node2D

@export var starting_rotation: int = 0

func _ready():
	$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))
