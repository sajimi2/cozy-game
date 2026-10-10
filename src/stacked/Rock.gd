extends StaticBody2D

func _ready():
	randomize()
	$StackedSprite.rotate_sprites(deg_to_rad(randf_range(0, 360.0)))
