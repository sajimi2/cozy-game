@tool
extends Node2D

signal entered
signal exited
signal interacted(body)

@export var time_per_character: float = 0.05
@export var text_to_say: String = ""
@export var circle_radius: int = 8: set = set_circle_radius
@export var collision_radius: int = 28: set = set_collision_radius
@export var circle_color: Color = Color("#838a54")

@export var starting_arc_angle: float = 0.0
@export var show_circle: bool = false
@export var bubble_offset: Vector2 = Vector2(0, -22): set = set_bubble_offset

@export var symbol: Texture2D = null: set = set_symbol

var body_ref = null

func set_circle_radius(_circle_radius):
	circle_radius = _circle_radius
	if find_child("Label"):
		queue_redraw()

func set_bubble_offset(_bubble_offset):
	bubble_offset = _bubble_offset
	if find_child("Label"):
		$Bubble.position = bubble_offset

func set_symbol(_symbol):
	symbol = _symbol
	if find_child("Label"):
		$Bubble/Symbol.texture = symbol

func set_collision_radius(_collision_radius):
	collision_radius = _collision_radius
	if find_child("Label"):
		$Area2D/CollisionShape2D.shape.radius = _collision_radius
		queue_redraw()

func _ready():
	show_circle = false
	$Label.text = ""
	$Bubble.hide()

func _process(delta):
	if show_circle:
		starting_arc_angle += delta * 125.0
		queue_redraw()
	if Input.is_action_just_pressed("ui_accept") and show_circle:
		emit_signal("interacted", body_ref)
		get_tree().call_group("player", "turn_towards", global_position)

func set_text(text):
	$Label.text = ""
	for i in range(0, len(text) + 1):
		$Label.text = text.substr(0, i)
		await get_tree().create_timer(0.05).timeout

func _draw():
	if !show_circle:
		return
	var degrees_per_arc = 30
	var space_between_arcs = 20
	var current_angle = starting_arc_angle
	var arc_width = 2.0
	while current_angle < 360.0 + starting_arc_angle:
		draw_arc(Vector2(0, 1), circle_radius, deg_to_rad(current_angle), deg_to_rad(current_angle + degrees_per_arc), 8, circle_color, arc_width)
		current_angle += degrees_per_arc + space_between_arcs

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body_ref = body
		emit_signal("entered")
		$Bubble.show()
		show_circle = true
		queue_redraw()

func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		body_ref = null
		emit_signal("exited")
		$Bubble.hide()
		show_circle = false
		$Label.text = ""
		queue_redraw()

func _on_Bubble_frame_changed():
	$Bubble/Symbol.frame = $Bubble.frame
