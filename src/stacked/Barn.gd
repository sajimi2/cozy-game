extends Node2D

@export var starting_rotation: int = 30

@export var closed_barn: Texture2D = null

func _ready():
	if Globals.get_progress_level() == 6:
		open_barn()
	$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))
	$StaticBody2D.rotation_degrees = starting_rotation
	$BarnDoor.rotate_sprites(deg_to_rad(starting_rotation))

func open_barn():
	$BarnDoor.queue_free()
	$StaticBody2D/DoorCollider.queue_free()

func _on_BarnEntrance_body_entered(body):
	if "Player" in body.name:
		body.can_move = false
		TransitionScreen.slow_transition_scene_to(Globals.BarnArea)
