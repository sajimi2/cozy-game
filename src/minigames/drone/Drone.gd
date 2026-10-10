extends CharacterBody2D

const Smoke = preload("res://src/minigames/drone/Smoke.tscn")

@export var shadow_color: Color = Color.WHITE

@onready var propellers = $Propellers.get_children()

enum HeightZone {
	TOP, MID, BOTTOM
}

var current_rotation = 0.0
var next_rotation = 0.0
var total_height = 0.0

var can_move = false
var is_dead = false
var current_height_zone = HeightZone.BOTTOM

func set_can_move(_can_move):
	can_move = _can_move
	$Bubble.show()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and can_move:
		AudioManager.play_sfx("CanceledMinigame")
		die()

func _ready():
	spawn_smoke_at_position.call_deferred()
	if Globals.has_completed_frog:
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)

func _physics_process(delta):
	if !can_move:
		return
	get_tree().call_group("interactable_creatures", "turn_towards", global_position)
	get_tree().call_group("player", "turn_towards", global_position)
	for propeller in $Propellers.get_children():
		propeller.rotate(delta * current_rotation)
	if current_rotation > next_rotation:
		current_rotation = lerp(current_rotation, next_rotation, 0.25 * delta)
	else:
		current_rotation = lerp(current_rotation, next_rotation, 1.0 * delta)
	if Input.is_action_just_pressed("ui_accept"):
		AudioManager.play_ambient("Drone")
		next_rotation = 20.0
	if Input.is_action_just_released("ui_accept"):
		AudioManager.stop_all_ambient()
		next_rotation = 0.0
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input.x != 0.0 and input.y != 0.0:
		$Propellers.rotation_degrees = 45
		$Propellers.position = Vector2(-2, -2)
	else:
		$Propellers.rotation_degrees = 0
		$Propellers.position = Vector2(0, 0)
	if input != Vector2.ZERO:
		$Drone.rotate_sprites(input.normalized().angle() + deg_to_rad(90))
	var speed = input.normalized() * 15.0 * (-total_height / 1000.0)
	if total_height > -50:
		speed = Vector2.ZERO
	var height = Vector2.ZERO
	if Input.is_action_pressed("ui_accept") and total_height > -2000:
		height += Vector2.UP * current_rotation
	elif total_height < 0:
		height += Vector2.DOWN * (20.0 - current_rotation)
	total_height += height.y
	queue_redraw()
	if $Bubble.visible:
		set_velocity(speed + height)
		move_and_slide()
		if current_height_zone == HeightZone.TOP:
			$Bubble.hide()
	else:
		match current_height_zone:
			HeightZone.BOTTOM:
				set_velocity(speed + height + (Globals.wind * 0))
				move_and_slide()
			HeightZone.MID:
				set_velocity(speed + height + (Globals.wind * 1))
				move_and_slide()
			HeightZone.TOP:
				set_velocity(speed + height + (Globals.wind * 2))
				move_and_slide()
	if total_height > -25 and !$FlyingCollider/CollisionShape2D.disabled:
		$FlyingCollider/CollisionShape2D.disabled = true
	elif total_height <= -25 and $FlyingCollider/CollisionShape2D.disabled:
		$FlyingCollider/CollisionShape2D.disabled = false
	if total_height > -25 and $LandedCollider/CollisionShape2D.disabled:
		$LandedCollider/CollisionShape2D.disabled = false
	elif total_height <= -25 and !$LandedCollider/CollisionShape2D.disabled:
		$LandedCollider/CollisionShape2D.disabled = true
	if total_height < -1333 and current_height_zone != HeightZone.TOP:
		current_height_zone = HeightZone.TOP
		get_tree().call_group("lake_trees", "enable_top_collider")
	elif total_height > -1333 and total_height < -666 and current_height_zone != HeightZone.MID:
		current_height_zone = HeightZone.MID
		get_tree().call_group("lake_trees", "enable_mid_collider")
	elif total_height > -666 and current_height_zone != HeightZone.BOTTOM:
		current_height_zone = HeightZone.BOTTOM
		get_tree().call_group("lake_trees", "enable_bottom_collider")
	if position.x > -64 and z_index == 0:
		z_index = 1
	elif position.x < -64 and z_index == 1:
		z_index = 0
	if position.x > 0:
		die()
	
func die():
	if is_dead:
		return
	is_dead = true
	spawn_smoke_at_position()
	AudioManager.play_sfx("Exploded")
	get_tree().call_group("frog", "failed_minigame")
	queue_free()

func spawn_smoke_at_position():
	var next_smoke = Smoke.instantiate()
	get_parent().add_child(next_smoke)
	next_smoke.global_position = global_position

func _draw():
	draw_circle(Vector2(0, -total_height / 100.0), 6, shadow_color)

func _on_LandedCollider_area_entered(area):
	if "Water" in area.name:
		die()
	if "LandingArea" in area.name and !Globals.has_completed_frog:
		z_index = 0
		$FlyingCollider/CollisionShape2D.set_deferred("disabled", true)
		$LandedCollider/CollisionShape2D.set_deferred("disabled", true)
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
		get_tree().call_group("frog", "won_minigame")
		can_move = false

func _on_FlyingCollider_area_entered(area):
	pass # Replace with function body.

func _on_FlyingCollider_body_entered(body):
	if "LakeTree" in body.name:
		die()

func _on_Bubble_frame_changed():
	$Bubble/Symbol.frame = $Bubble.frame
