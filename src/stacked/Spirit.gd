extends Area2D

@export var speed: float = 35.0
@export var frames = [] # (Array, Texture2D)

@export var ghost_colors = [] # (Array, Color)

var direction = Vector2.ZERO
var follow_player = false
var current_rotation = 0.0
var next_rotation = 0.0
var rotation_speed = 5.0

var chase_offset = Vector2.ZERO

func _ready():
	speed = randf_range(30, 36)
	chase_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	direction = Vector2(randf_range(-1, 1), 1).normalized()
	next_rotation = direction.angle() + deg_to_rad(90)
	scale = Vector2.ZERO
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	modulate = ghost_colors[randi() % len(ghost_colors)]
	AudioManager.play_sfx("SpiritSpawned")

func turn_towards(global_pos):
	next_rotation = global_position.angle_to_point(global_pos) + deg_to_rad(90)
	if abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation)) > 180.0:
		if next_rotation > current_rotation:
			next_rotation -= deg_to_rad(360.0)
		else:
			next_rotation += deg_to_rad(360.0)
	var rotation_distance = abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation))
	rotation_speed = max(5.0, rotation_distance / 5)

func _process(delta):
	current_rotation = lerp(current_rotation, next_rotation, 5 * delta)
	if follow_player:
		turn_towards(Globals.current_player_position + chase_offset)
		direction = global_position.direction_to(Globals.current_player_position + chase_offset)
	global_position += direction * speed * delta
	$StackedSprite.rotate_sprites(current_rotation)

func set_frame(frame):
	$StackedSprite.texture = frames[frame]
	$StackedSprite.render_sprites()
	$StackedSprite.rotate_sprites(current_rotation)

func _on_DeathTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()

func _on_FollowPlayerTimer_timeout():
	follow_player = true

func _on_Spirit_body_entered(body):
	if "Player" in body.name:
		get_tree().call_group("north_area", "failed_minigame")
		get_tree().call_group("scarecrow", "failed_minigame")
