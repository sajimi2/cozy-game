extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

@export var starting_rotation: int = 30

@export var closed_barn: Texture2D = null

func _ready():
	if Globals.get_progress_level() == 6:
		open_barn()
	else:
		add_locked_door_hint()
	$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))
	$StaticBody2D.rotation_degrees = starting_rotation
	$BarnDoor.rotate_sprites(deg_to_rad(starting_rotation))

func open_barn():
	$BarnDoor.queue_free()
	$StaticBody2D/DoorCollider.queue_free()
	var locked_door_hint = $StaticBody2D.get_node_or_null("LockedDoorHint")
	if locked_door_hint:
		TextBox.hide_hint(locked_door_hint)
		locked_door_hint.queue_free()

# 谷仓门没开时，走到门口提示还差几位朋友。
func add_locked_door_hint():
	var area = Area2D.new()
	area.name = "LockedDoorHint"
	area.position = Vector2(0, 28)
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = 16
	area.add_child(collision_shape)
	$StaticBody2D.add_child(area)
	area.body_entered.connect(_on_LockedDoorHint_body_entered.bind(area))
	area.body_exited.connect(_on_LockedDoorHint_body_exited.bind(area))

func _on_LockedDoorHint_body_entered(body, area):
	if "Player" in body.name:
		TextBox.show_hint(HintText.BARN_LOCKED % (6 - Globals.get_progress_level()), area)

func _on_LockedDoorHint_body_exited(body, area):
	if "Player" in body.name:
		TextBox.hide_hint(area)

func _on_BarnEntrance_body_entered(body):
	if "Player" in body.name:
		body.can_move = false
		TransitionScreen.slow_transition_scene_to(Globals.BarnArea)
