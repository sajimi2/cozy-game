extends Node2D

var wind_direction = Vector2.ZERO
var current_strength = 0.0
var max_strength = 10.0

func _ready():
	max_strength = randf_range(3, 6)

func _process(delta):
	current_strength = lerp(current_strength, max_strength, 1 * delta)
	if abs(current_strength - max_strength) < .1:
		max_strength = 0.0
	Globals.wind = wind_direction * current_strength

func stop_wind():
	$Timer.stop()

func start_wind():
	wind_direction = Vector2.UP.rotated(deg_to_rad(randf_range(0, 360)))
	max_strength = randf_range(3, 6)
	$Timer.start()

func _on_Timer_timeout():
	$Timer.wait_time = randf_range(5, 7)
	wind_direction = Vector2.UP.rotated(deg_to_rad(randf_range(0, 360)))
	max_strength = randf_range(3, 6)
