extends Node2D

const Leaf = preload("res://src/effects/Leaf.tscn")

@export var leaf_textures = [] # (Array, Texture2D)

func _ready():
	spawn_leaf.call_deferred()

func spawn_leaf():
	var next_leaf = Leaf.instantiate()
	get_parent().add_child(next_leaf)
	next_leaf.assign_texture(leaf_textures[randi() % len(leaf_textures)])
	next_leaf.global_position = global_position + Vector2(randf_range(-4, 4), randf_range(-4, 4))

func _on_Timer_timeout():
	spawn_leaf()
	$Timer.wait_time = randf_range(1.4, 1.8)
