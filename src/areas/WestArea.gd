extends Node2D

const Drone = preload("res://src/minigames/drone/Drone.tscn")
const FoundEgg = preload("res://src/stacked/FoundEgg.tscn")

func _on_ToMainArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "WestArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.MainArea)

func spawn_egg():
	var egg = FoundEgg.instantiate()
	$Node2D.add_child(egg)
	egg.position = $EggLocation.position if $EggLocation.position.distance_to($Node2D/Player.position) > 10 else $EggLocation2.position

func _ready():
	Globals.has_left_starting_area = true
	if Globals.last_scene_name == "MainArea":
		$Node2D/Player.position = Vector2(178.0, Globals.last_player_position.y - 72)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(-90.0))
	$WaterAreas.show()
	if Globals.has_completed_frog:
		$Node2D/Drone.global_position = Vector2(-24, 104)
	if Globals.has_completed_dodo:
		spawn_egg()

func _on_ChangeCameraLeft_body_entered(body):
	if "Player" in body.name:
		$Camera2D.position = Vector2(-110, 75)

func _on_ChangeCameraRight_body_entered(body):
	if "Player" in body.name:
		$Camera2D.position = Vector2(110, 75)

func spawn_drone():
	var next_drone = Drone.instantiate()
	next_drone.position = Vector2(-169, 27)
	$Node2D.add_child(next_drone)

func _on_WestArea_tree_exiting():
	Globals.wind = Vector2.ZERO

func _on_WindStart_body_entered(body):
	if "Drone" in body.name:
		get_tree().call_group("wind_generator", "start_wind")

func _on_WindStart_area_entered(area):
	if "FlyingCollider" in area.name:
		get_tree().call_group("wind_generator", "start_wind")
