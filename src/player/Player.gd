extends CharacterBody2D

@export var speed: int = 75

@export var idle_frames = [] # (Array, Texture2D)
@export var idle_feet_frames = [] # (Array, Texture2D)
@export var walk_feet_frames = [] # (Array, Texture2D)

var input = Vector2.ZERO
var last_input = Vector2.ZERO
var current_rotation = 0.0
var next_rotation = 0.0
var rotation_speed = 10.0

var can_move = true

func _ready():
	if get_tree().current_scene.name == "EastArea":
		$CollisionShape2D.shape.radius = 3
	else:
		$CollisionShape2D.shape.radius = 6
	
	if get_tree().current_scene.name == "StartingArea" and !CircleTransition.finished_transition:
		freeze_player()
		await get_tree().create_timer(3.5).timeout
		unfreeze_player()
		AudioManager.play_main_music()

func freeze_player():
	can_move = false

func unfreeze_player():
	can_move = true

func _physics_process(delta):
	Globals.current_player_position = global_position
	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
		return
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		return
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	current_rotation = lerp(current_rotation, next_rotation, delta * rotation_speed)
	$StackedSprite.rotate_sprites(current_rotation)
	if input == Vector2.ZERO or !can_move:
		if $AnimationPlayer.current_animation == "walk":
			$AnimationPlayer.play("idle")
		return
	if input != last_input:
		next_rotation = input.angle() + deg_to_rad(90)
		if abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation)) > 180.0:
			if next_rotation > current_rotation:
				next_rotation -= deg_to_rad(360.0)
			else:
				next_rotation += deg_to_rad(360.0)
		var rotation_distance = abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation))
		rotation_speed = max(5.0, rotation_distance / 5)
		last_input = input
	set_velocity(input.normalized() * speed)
	move_and_slide()
	if $AnimationPlayer.current_animation == "idle":
		$AnimationPlayer.play("walk")

func turn_towards(global_pos):
	next_rotation = global_position.angle_to_point(global_pos) + deg_to_rad(90)
	if abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation)) > 180.0:
		if next_rotation > current_rotation:
			next_rotation -= deg_to_rad(360.0)
		else:
			next_rotation += deg_to_rad(360.0)
	var rotation_distance = abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation))
	rotation_speed = max(5.0, rotation_distance / 5)
	last_input = Vector2.ZERO

func rotate_all_sprites(_rotation):
	current_rotation = _rotation
	next_rotation = _rotation
	$StackedSprite.rotate_sprites(_rotation)
	$Feet.rotate_sprites(_rotation)

func set_idle_animation(frame):
	$StackedSprite.texture = idle_frames[frame]
	$StackedSprite.render_sprites()
	$StackedSprite.rotate_sprites(current_rotation)
	
	$Feet.texture = idle_feet_frames[frame]
	$Feet.render_sprites()
	$Feet.rotate_sprites(current_rotation)

func set_walk_animation(frame):
	$StackedSprite.texture = idle_frames[frame]
	$StackedSprite.render_sprites()
	$StackedSprite.rotate_sprites(current_rotation)
	
	$Feet.texture = walk_feet_frames[frame]
	$Feet.render_sprites()
	$Feet.rotate_sprites(current_rotation)

func take_step_sfx():
	AudioManager.play_sfx("TakeStep")

func _on_ToStartingArea_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene_to_file("res://src/areas/StartingArea.tscn")
