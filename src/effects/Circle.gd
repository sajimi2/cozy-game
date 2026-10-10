extends Control

@export var center_point: Vector2 = Vector2(96, 72)

var radius = 0.0

func start_transition():
	await get_tree().create_timer(0.25).timeout
	radius = 10.0
	$Black.show()
	var tween := create_tween()
	tween.tween_property(self, "radius", 375.0, 5.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	get_parent().finish_transition()

func _process(delta):
	queue_redraw()
	if radius >= 10.0 and $Black.visible:
		$Black.hide()

func _draw():
	if radius <= 0.0:
		return
	for i in range(0, 32):
		draw_arc(center_point, radius * i, deg_to_rad(0), deg_to_rad(450), 128, Color.BLACK, radius * 1.25)

