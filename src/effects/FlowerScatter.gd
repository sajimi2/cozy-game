extends Node2D

# 在草地上随机散布小野花（白、粉、黄），避开 avoid 里列出的路面、湖面等节点。
# 随机种子固定，每次进入区域花的位置都一样。

const COLORS = [Color8(255, 251, 232), Color8(244, 196, 212), Color8(250, 226, 130)]
const STEM = Color8(96, 150, 84)
const DENSITY = 0.004

@export var area: Rect2 = Rect2(0, 0, 192, 144)
@export var flower_seed: int = 7
@export var avoid: Array[NodePath] = []

var images = {}

func _ready():
	queue_redraw()

func is_blocked(point):
	var global_point = to_global(point)
	for path in avoid:
		var node = get_node_or_null(path)
		if node is Sprite2D:
			if !images.has(node):
				images[node] = node.texture.get_image()
			var image = images[node]
			var local = node.to_local(global_point)
			if node.centered:
				local += Vector2(image.get_width(), image.get_height()) / 2.0
			if local.x >= 0 and local.y >= 0 and local.x < image.get_width() and local.y < image.get_height():
				if image.get_pixelv(Vector2i(local)).a > 0.0:
					return true
		elif node is Polygon2D:
			if Geometry2D.is_point_in_polygon(node.to_local(global_point), node.polygon):
				return true
	return false

func _draw():
	var rng = RandomNumberGenerator.new()
	rng.seed = flower_seed
	for i in int(area.get_area() * DENSITY):
		var point = Vector2(rng.randf_range(area.position.x, area.end.x), rng.randf_range(area.position.y, area.end.y)).floor()
		var color = COLORS[rng.randi() % COLORS.size()]
		var big = rng.randf() < 0.5
		if is_blocked(point):
			continue
		draw_rect(Rect2(point, Vector2(1, 1)), color)
		if big:
			draw_rect(Rect2(point + Vector2(1, 0), Vector2(1, 1)), color)
			draw_rect(Rect2(point + Vector2(0, -1), Vector2(1, 1)), STEM)
