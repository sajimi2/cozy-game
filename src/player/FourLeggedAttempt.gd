extends CharacterBody2D

@export var speed: int = 75
@export var leg_distance: int = 12
@export var axle_distance: int = 4

var input = Vector2.ZERO
var delta_move_sum = 0.0

@onready var current_top_left_leg_position = $TopLeftLegEnd.global_position
@onready var current_top_right_leg_position = $TopRightLegEnd.global_position
@onready var current_bottom_left_leg_position = $BottomLeftLegEnd.global_position
@onready var current_bottom_right_leg_position = $BottomRightLegEnd.global_position

func _ready():
	$TopLeftLegEnd.position = Vector2.DOWN.rotated(deg_to_rad(-30)) * leg_distance
	$TopRightLegEnd.position = Vector2.DOWN.rotated(deg_to_rad(30)) * leg_distance
	$BottomLeftLegEnd.position = Vector2.UP.rotated(deg_to_rad(30)) * leg_distance
	$BottomRightLegEnd.position = Vector2.UP.rotated(deg_to_rad(-30)) * leg_distance
	$FrontLegsAxle.position = Vector2.DOWN * axle_distance
	$BackLegsAxle.position = Vector2.UP * axle_distance

func _physics_process(delta):
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input == Vector2.ZERO:
		return
	delta_move_sum += delta
	input = input.normalized()
	$FrontLegsAxle.position = input * axle_distance
	$BackLegsAxle.position = -input * axle_distance
	$TopLeftLegEnd.position = $FrontLegsAxle.position + input.rotated(deg_to_rad(-30)) * leg_distance
	$TopRightLegEnd.position = $FrontLegsAxle.position + input.rotated(deg_to_rad(30)) * leg_distance
	$BottomLeftLegEnd.position = $BackLegsAxle.position + input.rotated(deg_to_rad(-30)) * leg_distance
	$BottomRightLegEnd.position = $BackLegsAxle.position + input.rotated(deg_to_rad(30)) * leg_distance
	set_velocity(input * speed)
	move_and_slide()

func _process(delta):
	# Top Left Leg
	if current_top_left_leg_position.distance_to($TopLeftLegEnd.global_position) > leg_distance * 2:
		current_top_left_leg_position = $TopLeftLegEnd.global_position
	# Top Right Leg
	if current_top_right_leg_position.distance_to($TopRightLegEnd.global_position) > leg_distance * 2:
		current_top_right_leg_position = $TopRightLegEnd.global_position
	# Bottom Left Leg
	if current_bottom_left_leg_position.distance_to($BottomLeftLegEnd.global_position) > leg_distance * 2:
		current_bottom_left_leg_position = $BottomLeftLegEnd.global_position
	# Bottom Right Leg
	if current_bottom_right_leg_position.distance_to($BottomRightLegEnd.global_position) > leg_distance * 2:
		current_bottom_right_leg_position = $BottomRightLegEnd.global_position
	queue_redraw()

func _draw():
	draw_line($FrontLegsAxle.position, current_top_left_leg_position - global_position, Color.YELLOW, 1.0)
	draw_line($FrontLegsAxle.position, current_top_right_leg_position - global_position, Color.YELLOW, 1.0)
	draw_line($BackLegsAxle.position, current_bottom_left_leg_position - global_position, Color.YELLOW, 1.0)
	draw_line($BackLegsAxle.position, current_bottom_right_leg_position - global_position, Color.YELLOW, 1.0)
	
#	draw_circle($TopLeftLegEnd.position, 3, Color.green)
	draw_circle(current_top_left_leg_position - global_position, 2, Color.YELLOW)
#	draw_circle($TopRightLegEnd.position, 3, Color.green)
	draw_circle(current_top_right_leg_position - global_position, 2, Color.YELLOW)
#	draw_circle($BottomLeftLegEnd.position, 3, Color.green)
	draw_circle(current_bottom_left_leg_position - global_position, 2, Color.YELLOW)
#	draw_circle($BottomRightLegEnd.position, 3, Color.green)
	draw_circle(current_bottom_right_leg_position - global_position, 2, Color.YELLOW)

	draw_circle(Vector2.ZERO, 5, Color.RED)
	draw_circle($FrontLegsAxle.position, 3, Color.BLUE)
	draw_circle($BackLegsAxle.position, 3, Color.BLUE)
	
#	draw_circle($BottomLeftLegEnd.position, 1, Color.red)
#	draw_circle($BottomRightLegEnd.position, 1, Color.red)
#	draw_circle($TopLeftLegEnd.position, 1, Color.red)
#	draw_circle($TopRightLegEnd.position, 1, Color.red)
