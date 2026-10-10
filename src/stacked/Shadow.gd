extends Node2D

@export var shadow_radius: int = 8
@export var shadow_color: Color = Color("#454259")

func _draw():
	draw_circle(Vector2.ZERO, shadow_radius, shadow_color)
