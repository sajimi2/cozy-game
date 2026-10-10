extends Line2D

const FencePost = preload("res://src/stacked/FencePost.tscn")

@export var dark_brown: Color = Color("#543942")
@export var medium_brown: Color = Color("#7a5550")
@export var light_brown: Color = Color("#a17e67")

@export var fence_height: int = 12
@export var fence_width: int = 2

func _ready():
	if !visible:
		return
	$CopyLine.default_color = Color("#7a5550")
	await get_tree().create_timer(0.05).timeout
	setup_fence()
	width = 0.0
	for i in range(0, len(points) - 1):
		var next_wall = $Wall.duplicate()
		var next_segment = SegmentShape2D.new()
		next_segment.a = points[i]
		next_segment.b = points[i + 1]
		next_wall.get_node("CollisionShape2D").shape = next_segment
		$Walls.add_child(next_wall)
	$CopyLine.queue_free()
	$Wall.queue_free()

func setup_fence():
	for point in points:
		var next_fence_post = FencePost.instantiate()
		get_parent().add_child(next_fence_post)
		next_fence_post.position = point
	for j in range(0, 6):
		for i in range(0, len(points) - 1):
			var offset = Vector2(0, -2 - j)
			if j == 5:
				offset = Vector2(0, 1)
			var first_to_half_line = $CopyLine.duplicate()
			get_parent().add_child(first_to_half_line)
			var halfway_point = (points[i + 1] + points[i]) / 2.0
			first_to_half_line.position = halfway_point + offset
			first_to_half_line.points = [Vector2.ZERO, points[i] - halfway_point]
			first_to_half_line.points[1] -= first_to_half_line.points[0].direction_to(first_to_half_line.points[1]) * 3

			var half_to_end_line = $CopyLine.duplicate()
			get_parent().add_child(half_to_end_line)
			halfway_point = (points[i + 1] + points[i]) / 2.0
			half_to_end_line.position = halfway_point + offset
			half_to_end_line.points = [Vector2.ZERO, points[i + 1] - halfway_point]
			half_to_end_line.points[1] -= half_to_end_line.points[0].direction_to(half_to_end_line.points[1]) * 3

			if j == 0:
				first_to_half_line.default_color = Color("#543942")
				half_to_end_line.default_color = Color("#543942")
				first_to_half_line.position += Vector2(0, -4)
				first_to_half_line.points[0] += Vector2(0, 4)
				first_to_half_line.points[1] += Vector2(0, 4)
				half_to_end_line.position += Vector2(0, -4)
				half_to_end_line.points[0] += Vector2(0, 4)
				half_to_end_line.points[1] += Vector2(0, 4)
			elif j == 4:
				first_to_half_line.default_color = Color("#a17e67")
				half_to_end_line.default_color = Color("#a17e67")
				
				first_to_half_line.position += Vector2(0, 3)
				first_to_half_line.points[0] += Vector2(0, -3)
				first_to_half_line.points[1] += Vector2(0, -3)
				half_to_end_line.position += Vector2(0, 3)
				half_to_end_line.points[0] += Vector2(0, -3)
				half_to_end_line.points[1] += Vector2(0, -3)
			elif j == 5:
				first_to_half_line.default_color = Color("#0e174a35")
				half_to_end_line.default_color = Color("#0e174a35")
				
				first_to_half_line.position += Vector2(0, -6)
				first_to_half_line.points[0] += Vector2(0, 6)
				first_to_half_line.points[1] += Vector2(0, 6)
				half_to_end_line.position += Vector2(0, -6)
				half_to_end_line.points[0] += Vector2(0, 6)
				half_to_end_line.points[1] += Vector2(0, 6)
