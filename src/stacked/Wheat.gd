extends Node2D

@export var wheats = [] # (Array, Texture2D)

func _ready():
	$StackedSprite.texture = wheats[randi() % len(wheats)]
	if randi() % 3 == 0:
		$StackedSprite.flip_h = true
	$StackedSprite.render_sprites()
