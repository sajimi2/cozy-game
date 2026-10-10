extends CanvasLayer

var finished_transition = false

func _ready():
	$Circle.hide()

func finish_transition():
	$Circle.hide()
	finished_transition = true

func transition_out(center):
	$Circle.show()
	finished_transition = false
	$Circle.center_point = center
	$Circle.start_transition()
