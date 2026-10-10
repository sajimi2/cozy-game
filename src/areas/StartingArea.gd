extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

func _on_ToMainArea_body_entered(body):
	if "Player" in body.name:
		Globals.last_scene_name = "StartingArea"
		Globals.last_player_position = $Node2D/Player.global_position
		TransitionScreen.transition_scene_to(Globals.MainArea)

func _ready():
	if !Globals.has_left_starting_area:
		CircleTransition.transition_out(Vector2(96, 72))
	if Globals.last_scene_name == "MainArea":
		$Node2D/Player.position = Vector2(Globals.last_player_position.x, -128)
		$Node2D/Player.rotate_all_sprites(deg_to_rad(180.0))
	if Globals.should_show_area_hint("StartingArea"):
		# 等开场转场结束、角色可以移动后再提示操作。
		await get_tree().create_timer(3.5).timeout
		TextBox.show_hint(HintText.CONTROLS, self, false, 6.0)
