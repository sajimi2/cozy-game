extends Node2D

var speed = 20

@onready var direction = Vector2.UP
@onready var rotation_speed = randf_range(1.0, 2.0)

func _ready():
	randomize()
	speed = randf_range(10, 20)
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func assign_texture(texture):
	$Leaf.texture = texture
	$Shadow.texture = texture
	var tween := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Shadow, "position", Vector2.ZERO, 8.0).from(Vector2(0, 10)).finished.connect(_finish_shadow)
	tween.tween_property(self, "speed", 0.0, 10.0)

func set_direction(dir):
	direction = dir

func _physics_process(delta):
	if Globals.wind != Vector2.ZERO:
		position += Globals.wind * speed * delta
	else:
		position += direction * speed * delta
	$Leaf.rotate(delta * rotation_speed)
	if find_child("Shadow"):
		$Shadow.rotate(delta * rotation_speed)

func _on_Timer_timeout():
	$AnimationPlayer.play("fade_out")

func _finish_shadow():
	if find_child("Shadow"):
		$Shadow.queue_free()
		create_tween().tween_property(self, "rotation_speed", 0.0, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_BehindTimer_timeout():
	show_behind_parent = true

func _on_ShowShadow_timeout():
	$Shadow.show()
