extends CharacterBody2D

@export var speed: int = 75
@export var y_offset: float = 1.0
@export var squash_shader: ShaderMaterial = null
var input = Vector2.ZERO
var left_leg_position = Vector2(-16, 0)
var right_leg_position = Vector2(16, 0)

var last_input = Vector2.DOWN
var viewing_angle = 0.0
var breathing_offset = 0.0

func _ready():
	squash_shader.set_shader_parameter("angle", viewing_angle)
	squash_shader.set_shader_parameter("rotation", 0.0)
	render_sprites()
	await get_tree().create_timer(0.1).timeout
	left_leg_position = position
	right_leg_position = position

func _process(delta):
	breathing_offset = sin(Time.get_ticks_msec() / 250.0)
	update_legs()

func _physics_process(delta):
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input == Vector2.ZERO:
		return
	set_velocity(input.normalized() * speed)
	move_and_slide()
	rotate_sprites(input.normalized().angle() - deg_to_rad(90))
	$StackedSprite.rotate_sprites(input.angle() + deg_to_rad(90))
	last_input = input.normalized()

func update_legs():
	var leg_width = 3.0
	var left_leg_starting_position = Vector2(0, -4) + (last_input.rotated(deg_to_rad(-90)) * 5) - last_input * 1
	var left_leg_length = left_leg_starting_position.distance_to(left_leg_position - position)
	$LeftLeg.points[0] = left_leg_starting_position
	$LeftLeg.points[1] = left_leg_position - position
	
	if left_leg_length > 16.0 and input != Vector2.ZERO:
		var next_left_leg_position = input.normalized().rotated(deg_to_rad(-20)) * 12.0 + position
		left_leg_position = next_left_leg_position

	var right_leg_starting_position = Vector2(0, -4) + (last_input.rotated(deg_to_rad(90)) * 5) - last_input * 1
	var right_leg_length = right_leg_starting_position.distance_to(right_leg_position - position)
	$RightLeg.points[0] = right_leg_starting_position
	$RightLeg.points[1] = right_leg_position - position
	
	if right_leg_length > 16.0 and input != Vector2.ZERO:
		var next_right_leg_position = input.normalized().rotated(deg_to_rad(20)) * 12.0 + position
		right_leg_position = next_right_leg_position
	queue_redraw()

func _draw():
	draw_circle($RightLeg.points[1], 2, Color("#9e6333"))
	draw_circle($LeftLeg.points[1], 2, Color("#9e6333"))
	return
	
	var leg_width = 3.0
	var left_leg_starting_position = (last_input.rotated(deg_to_rad(-90)) * 4) + last_input * 2
	var left_leg_length = left_leg_starting_position.distance_to(left_leg_position - position)
	draw_line(left_leg_starting_position, left_leg_position - position, Color("#57664c"), leg_width)
	
	if left_leg_length > 16.0 and input != Vector2.ZERO:
		var next_left_leg_position = input.normalized().rotated(deg_to_rad(-15)) * 16.0 + position
		if next_left_leg_position.distance_to(right_leg_position) > 12.0:
			left_leg_position = next_left_leg_position

	var right_leg_starting_position = (last_input.rotated(deg_to_rad(90)) * 4) + last_input * 2
	var right_leg_length = right_leg_starting_position.distance_to(right_leg_position - position)
	draw_line(right_leg_starting_position, right_leg_position - position, Color("#57664c"), leg_width)
	
	if right_leg_length > 16.0 and input != Vector2.ZERO:
		var next_right_leg_position = input.normalized().rotated(deg_to_rad(15)) * 16.0 + position
		if next_right_leg_position.distance_to(left_leg_position) > 12.0:
			right_leg_position = next_right_leg_position
#	draw_circle(Vector2(0, -breathing_offset), 12, Color("#838a54"))

func rotate_sprites(_rotation):
	for sprite in $Body.get_children():
		sprite.rotation = _rotation
	squash_shader.set_shader_parameter("rotation", rad_to_deg(_rotation))

func clear_sprites():
	for sprite in $Body.get_children():
		sprite.queue_free()

func render_sprites():
	clear_sprites()
	render_sprites_from_sprite($Body)

func render_sprites_from_sprite(sprite):
	for i in range(0, sprite.hframes):
		var next_sprite = Sprite2D.new()
		next_sprite.texture = sprite.texture
		next_sprite.hframes = sprite.hframes
		next_sprite.frame = i
		next_sprite.position.y = -i * cos(deg_to_rad(viewing_angle)) * y_offset
		next_sprite.position.y += breathing_offset
#		next_sprite.self_modulate = Color("#838a54")
#		next_sprite.self_modulate = next_sprite.self_modulate.darkened((sprite.hframes - 1 - i) * .1)
#		next_sprite.self_modulate = Color(randf(), randf(), randf())
#		next_sprite.material = squash_shader
		sprite.add_child(next_sprite)
