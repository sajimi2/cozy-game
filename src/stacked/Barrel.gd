extends Node2D

@export var starting_rotation: int = 30

func _ready():
	$StackedSprite.rotate_sprites(deg_to_rad(randf_range(0, 360)))
