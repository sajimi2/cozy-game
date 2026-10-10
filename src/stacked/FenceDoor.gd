extends Node2D

@export var is_enabled: bool = false: set = set_is_enabled

func set_is_enabled(_is_enabled):
	is_enabled = _is_enabled
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", is_enabled)
