extends Area2D

@export var speed: float = 45.0
@export var frames = [] # (Array, Texture2D)

var direction = Vector2.ZERO

func _ready():
	scale = Vector2.ZERO
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	AudioManager.play_sfx("TinySpiritSpawned")

func _process(delta):
	global_position += direction * speed * delta
	$StackedSprite.rotate_sprites(direction.angle() - rad_to_deg(90))

func set_frame(frame):
	$StackedSprite.texture = frames[frame]
	$StackedSprite.render_sprites()
	$StackedSprite.rotate_sprites(direction.angle() - rad_to_deg(90))

func _on_Spirit_body_entered(body):
	if "Player" in body.name:
		get_tree().call_group("north_area", "failed_minigame")
		get_tree().call_group("scarecrow", "failed_minigame")

func _on_DeathTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()
