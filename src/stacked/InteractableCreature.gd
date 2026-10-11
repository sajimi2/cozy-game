@tool
extends Node2D

const Heart = preload("res://sprites/ui/symbols/Heart.png")

signal entered
signal exited
signal interacted(body)

@export var starting_rotation: int = 0: set = set_starting_rotation
@export var turn_towards_player: bool = true: set = set_turn_towards_player
@export var hframes: int = 1: set = set_hframes
@export var texture: Texture2D = null: set = set_texture
@export var shadow_radius: int = 8: set = set_shadow_radius

@export var arc_radius: int = 8: set = set_arc_radius
@export var arc_collision_radius: int = 28: set = set_arc_collision_radius
@export var collision_radius: int = 6: set = set_collision_radius

@export var bubble_offset: Vector2 = Vector2(0, -22): set = set_bubble_offset
@export var symbol: Texture2D = null: set = set_symbol

var current_rotation = 0.0
var next_rotation = 0.0
var rotation_speed = 5.0
# 走路时左右摇摆的额外角度（弧度）
var sway = 0.0

func _ready():
	$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))
	current_rotation = deg_to_rad(starting_rotation)
	next_rotation = deg_to_rad(starting_rotation)

func _process(delta):
	current_rotation = lerp(current_rotation, next_rotation, delta * rotation_speed)
	$StackedSprite.rotate_sprites(current_rotation + sway)

func turn_towards(global_pos):
	next_rotation = global_position.angle_to_point(global_pos) + deg_to_rad(90)
	if abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation)) > 180.0:
		if next_rotation > current_rotation:
			next_rotation -= deg_to_rad(360.0)
		else:
			next_rotation += deg_to_rad(360.0)
	var rotation_distance = abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation))
	rotation_speed = max(5.0, rotation_distance / 5)

func slow_turn_towards(global_pos):
	next_rotation = global_position.angle_to_point(global_pos) + deg_to_rad(90)
	if abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation)) > 180.0:
		if next_rotation > current_rotation:
			next_rotation -= deg_to_rad(360.0)
		else:
			next_rotation += deg_to_rad(360.0)
	var rotation_distance = abs(rad_to_deg(next_rotation) - rad_to_deg(current_rotation))
	rotation_speed = max(0.1, rotation_distance / 25)

func set_bubble_offset(_bubble_offset):
	bubble_offset = _bubble_offset
	if find_child("StackedSprite"):
		$Interactable.bubble_offset = bubble_offset

func set_symbol(_symbol):
	symbol = _symbol
	if find_child("StackedSprite"):
		$Interactable.symbol = symbol

func set_turn_towards_player(_turn_towards_player):
	turn_towards_player = _turn_towards_player

func set_starting_rotation(_starting_rotation):
	starting_rotation = _starting_rotation
	if find_child("StackedSprite"):
		$StackedSprite.rotate_sprites(deg_to_rad(starting_rotation))

func set_hframes(_hframes):
	hframes = _hframes
	if find_child("StackedSprite"):
		$StackedSprite.hframes = hframes

func set_texture(_texture):
	texture = _texture
	if find_child("StackedSprite"):
		$StackedSprite.texture = texture
		$StackedSprite.rotate_sprites(current_rotation)

func set_shadow_radius(_shadow_radius):
	shadow_radius = _shadow_radius
	if find_child("StackedSprite"):
		$StackedSprite.shadow_radius = shadow_radius

func set_arc_radius(_arc_radius):
	arc_radius = _arc_radius
	if find_child("StackedSprite"):
		$Interactable.circle_radius = arc_radius
		queue_redraw()

func set_arc_collision_radius(_arc_collision_radius):
	arc_collision_radius = _arc_collision_radius
	if find_child("StackedSprite"):
		$Interactable.collision_radius = arc_collision_radius

func set_collision_radius(_collision_radius):
	collision_radius = _collision_radius
	if find_child("StackedSprite"):
		$StaticBody2D/CollisionShape2D.shape.radius = collision_radius

func _draw():
	if Engine.is_editor_hint():
		draw_arc(Vector2(0, 1), arc_radius, 0, 2 * PI, 16, Color.WHITE, 2.0)

func _on_Interactable_interacted(body):
	if turn_towards_player:
		turn_towards(body.global_position)
	emit_signal("interacted", body)

func _on_Interactable_entered():
	AudioManager.play_sfx("InteractionBubbleAppeared")
	emit_signal("entered")

func _on_Interactable_exited():
	emit_signal("exited")
