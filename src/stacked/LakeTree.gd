extends StaticBody2D

@export var tree_sprites = [] # (Array, Texture2D)

var delta_sum = 0.0
var distance_offset = 4.0
var speed_offset = 2.0

func _ready():
	randomize()
	$StackedSprite.texture = tree_sprites[randi() % len(tree_sprites)]
	$StackedSprite.render_sprites()
	distance_offset = randf_range(6, 8)
	speed_offset = randf_range(1.5, 2.5)
	await get_tree().create_timer(0.05).timeout
	$StackedSprite.rotate_sprites(deg_to_rad(randf_range(0, 360.0)))

func _process(delta):
	delta_sum += delta
	var next_rotation = sin(delta_sum / speed_offset) / distance_offset
	$StackedSprite.add_sprite_rotation(next_rotation / 100.0)

func enable_top_collider():
	$TopCollision.disabled = false
	$MidCollision.disabled = true
	$BottomCollision.disabled = true

func enable_mid_collider():
	$TopCollision.disabled = true
	$MidCollision.disabled = false
	$BottomCollision.disabled = true

func enable_bottom_collider():
	$TopCollision.disabled = true
	$MidCollision.disabled = true
	$BottomCollision.disabled = false
