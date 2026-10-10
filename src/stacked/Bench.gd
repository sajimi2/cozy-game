extends Node2D

@export var starting_rotation: int = -30

func _ready():
	$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))
	$StaticBody2D.rotation_degrees = starting_rotation
