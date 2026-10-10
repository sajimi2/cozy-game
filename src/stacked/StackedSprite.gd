@tool
extends Sprite2D

@export var show_sprites: bool = false: set = set_show_sprites
@export var show_sprite_rotation: bool = false: set = set_show_sprite_rotation
@export var stack_offset: int = 1: set = set_stack_offset
@export var shadow_radius: int = 8: set = set_shadow_radius
@export var shadow_color: Color = Color("#454259"): set = set_shadow_color

var rotation_amount = 0.0

func set_show_sprites(_show_sprites):
	show_sprites = _show_sprites
	if show_sprites:
		render_sprites()

func set_shadow_color(_shadow_color):
	shadow_color = _shadow_color
	queue_redraw()

func set_shadow_radius(_shadow_radius):
	shadow_radius = _shadow_radius
	queue_redraw()

func set_stack_offset(_stack_offset):
	stack_offset = _stack_offset

func set_show_sprite_rotation(_show_sprite_rotation):
	show_sprite_rotation = _show_sprite_rotation

func _ready():
	render_sprites()

func _process(delta):
	rotation_amount += delta
	if show_sprite_rotation:
		rotate_sprites(rotation_amount)

func rotate_sprites(_rotation):
	for sprite in get_children():
		sprite.rotation = _rotation

func add_sprite_rotation(_rotation):
	for sprite in get_children():
		sprite.rotation += _rotation

func clear_sprites():
	for child in get_children():
		if !"Shadow" in child.name:
			child.queue_free()

func render_sprites():
	clear_sprites()
	for i in range(0, hframes):
		var next_sprite = Sprite2D.new()
		add_child(next_sprite)
		next_sprite.texture = texture
		next_sprite.hframes = hframes
		next_sprite.frame = i
		next_sprite.position.y = -i * stack_offset
	if !Engine.is_editor_hint():
		texture = null

func _draw():
	draw_circle(Vector2(0, 1), shadow_radius, shadow_color)
