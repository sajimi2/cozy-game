extends StaticBody2D

@export var textures = [] # (Array, Texture2D)

# 春天版：原来的蘑菇换成几种小花，每株随机挑一种
func _ready():
	randomize()
	$StackedSprite.texture = textures[randi() % len(textures)]
	$StackedSprite.render_sprites()
	$StackedSprite.rotate_sprites(deg_to_rad(randf_range(0, 360.0)))
