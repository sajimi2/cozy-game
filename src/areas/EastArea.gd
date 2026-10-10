extends Node2D

const CornStalk = preload("res://src/stacked/CornStalk.tscn")
const Smoke = preload("res://src/minigames/drone/Smoke.tscn")

func _on_ToMainArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "EastArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.MainArea)

func spawn_smoke_at_position(pos):
	var next_smoke = Smoke.instantiate()
	$Node2D.add_child(next_smoke)
	next_smoke.position = pos

func _ready():
	Globals.has_left_starting_area = true
	for corn_line in $CornLines.get_children():
		for point in corn_line.points:
			var next_corn = CornStalk.instantiate()
			$Node2D.add_child(next_corn)
			next_corn.position = point
		corn_line.hide()
	for corn_line in $CornLines.get_children():
		for i in range(0, len(corn_line.points) - 1):
			var next_wall = $Wall.duplicate()
			var next_segment = SegmentShape2D.new()
			next_segment.a = corn_line.points[i]
			next_segment.b = corn_line.points[i + 1]
			next_wall.get_node("CollisionShape2D").shape = next_segment
			$Walls.add_child(next_wall)
	if Globals.last_scene_name == "MainArea":
		$Node2D/Player.position = Vector2(12.0, Globals.last_player_position.y - 72)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(90.0))

func _on_ChangeCameraLeft_body_entered(body):
	if "Player" in body.name:
		$Camera2D.position = Vector2(92, 75)

func _on_ChangeCameraRight_body_entered(body):
	if "Player" in body.name:
		$Camera2D.position = Vector2(300, 75)

func _on_TopLeftTeleporter_body_entered(body):
	if "Player" in body.name:
		AudioManager.play_sfx("Teleport")
		$Node2D/Player.position = $BottomLeftSpawn.position
		spawn_smoke_at_position($BottomLeftSpawn.position)

func _on_BottomLeftTeleporter_body_entered(body):
	if "Player" in body.name:
		AudioManager.play_sfx("Teleport")
		$Node2D/Player.position = $TopLeftSpawn.position
		spawn_smoke_at_position($TopLeftSpawn.position)

func _on_TopRightTeleporter_body_entered(body):
	if "Player" in body.name:
		AudioManager.play_sfx("Teleport")
		$Node2D/Player.position = $BottomRightSpawn.position
		spawn_smoke_at_position($BottomRightSpawn.position)

func _on_BottomRightTeleporter_body_entered(body):
	if "Player" in body.name:
		AudioManager.play_sfx("Teleport")
		$Node2D/Player.position = $TopRightSpawn.position
		spawn_smoke_at_position($TopRightSpawn.position)
