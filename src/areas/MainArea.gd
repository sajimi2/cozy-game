extends Node2D

func _on_ToStartingArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "MainArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.StartingArea)

func _ready():
	Globals.has_left_starting_area = true
	if Globals.last_scene_name == "StartingArea":
		$Node2D/Player.position = Vector2(Globals.last_player_position.x, 276)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(0.0))
	elif Globals.last_scene_name == "WestArea":
		$Node2D/Player.position = Vector2(-82, Globals.last_player_position.y + 72)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(90.0))
	elif Globals.last_scene_name == "EastArea":
		$Node2D/Player.position = Vector2(275, Globals.last_player_position.y + 72)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(-90.0))
	elif Globals.last_scene_name == "NorthArea":
		$Node2D/Player.position = Vector2(Globals.last_player_position.x, 19)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(180.0))

func _on_ToWestArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "MainArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.WestArea)

func _on_ToNorthArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "MainArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.NorthArea)

func _on_ToEastArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "MainArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.EastArea)
