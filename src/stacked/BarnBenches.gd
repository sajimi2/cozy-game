extends Node2D

# 谷仓门前摆成半圆的六张凳子，中间留出通往门口的路。帮助过的朋友会走到这里坐下，
# 等大家到齐、谷仓开门。座位按到达顺序从中间往两边坐；凳子可直接在场景里拖动。

const SEAT_HEIGHT = 9
const HOP_HEIGHT = 3.0
const HOP_SPEED = 10.0
const WALK_SPEED = 38.0
const DOOR_FACING = Vector2(-0.5, 0.866)
const RING_RADIUS = 62.0

# 来自其他地图的朋友用谷仓里的同款造型，从各自那条路的入口走进来。
const VISITORS = {
	"frog": preload("res://src/stacked/BarnFrog.tscn"),
	"dodo": preload("res://src/stacked/BarnDodo.tscn"),
	"scarecrow": preload("res://src/stacked/BarnScarecrow.tscn"),
	"ostrich": preload("res://src/stacked/BarnOstrich.tscn"),
}
const ENTRANCES = {
	"frog": [Vector2(-110, 140), Vector2(90, 141)],
	"dodo": [Vector2(-110, 140), Vector2(90, 141)],
	"ostrich": [Vector2(300, 150), Vector2(150, 152)],
}
# 稻草人走不了路，像玉米迷宫的传送点一样冒一团烟，直接出现在凳子上。
const TELEPORTERS = ["scarecrow"]
const Smoke = preload("res://src/minigames/drone/Smoke.tscn")
# 本来就住在中央广场的朋友，直接从原地走过来。
const RESIDENTS = {
	"chicken": "Chicken",
	"sheep": "Sheep",
}
const RESIDENT_PATHS = {
	"chicken": [],
	"sheep": [Vector2(-18, 138), Vector2(90, 141)],
}

@onready var seats = [$Seat1, $Seat2, $Seat3, $Seat4, $Seat5, $Seat6]

func _ready():
	seat_guests.call_deferred()

func seat_guests():
	for friend in Globals.barn_guests:
		var node = find_friend(friend)
		if node == null:
			node = spawn_visitor(friend)
		sit_down(node, Globals.barn_guests.find(friend), true)
	# 在别的地图帮完的朋友，玩家回到广场时跟着走进来。
	var delay = 0.6
	for friend in VISITORS:
		if Globals.has_completed(friend) and !Globals.barn_guests.has(friend):
			invite(friend, null, delay)
			delay += 0.8

func find_friend(friend):
	if RESIDENTS.has(friend):
		return get_parent().get_node_or_null(RESIDENTS[friend])
	return null

func spawn_visitor(friend):
	var visitor = VISITORS[friend].instantiate()
	get_parent().add_child(visitor)
	return visitor

func invite(friend, node = null, delay = 1.0):
	if Globals.barn_guests.has(friend):
		return
	Globals.barn_guests.push_back(friend)
	var seat_index = Globals.barn_guests.size() - 1
	await get_tree().create_timer(delay).timeout
	if TELEPORTERS.has(friend):
		teleport_to_seat(spawn_visitor(friend), seat_index)
		return
	var path = RESIDENT_PATHS.get(friend, [])
	if node == null:
		node = spawn_visitor(friend)
		node.global_position = ENTRANCES[friend][0]
		path = ENTRANCES[friend].slice(1)
	walk_to_seat(node, path, seat_index)

func teleport_to_seat(node, seat_index):
	sit_down(node, seat_index, true)
	var smoke = Smoke.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = seat_global(seat_index)
	AudioManager.play_sfx("Teleport")

# 坐下后面朝中间那条通往谷仓门的小路。
func aisle_point(seat_index):
	var door = $Door.global_position
	return door + DOOR_FACING * (seat_global(seat_index) - door).dot(DOOR_FACING)

# 从半圆正前方沿外圈绕到座位前，免得穿过别人的凳子。
func ring_path(seat_index):
	var door = $Door.global_position
	var seat_angle = DOOR_FACING.angle_to(seat_global(seat_index) - door)
	var points = []
	var steps = int(ceil(abs(seat_angle) / deg_to_rad(15.0)))
	for i in range(0, steps + 1):
		var angle = seat_angle * i / max(steps, 1)
		points.push_back(door + DOOR_FACING.rotated(angle) * RING_RADIUS)
	return points

func seat_global(seat_index):
	return seats[seat_index].global_position

func walk_to_seat(node, path, seat_index):
	var creature = node.get_node("InteractableCreature")
	var sprite = creature.get_node("StackedSprite")
	set_blocking(creature, false)
	var points = path + ring_path(seat_index)
	var hop_time = 0.0
	for target in points:
		creature.turn_towards(target)
		while node.global_position.distance_to(target) > 0.5:
			await get_tree().process_frame
			if !is_instance_valid(node) or !node.is_inside_tree():
				return
			var delta = get_process_delta_time()
			hop_time += delta
			node.global_position = node.global_position.move_toward(target, WALK_SPEED * delta)
			sprite.lift = int(round(abs(sin(hop_time * HOP_SPEED)) * HOP_HEIGHT))
	# 跳上凳子
	var start = node.global_position
	var seat = seat_global(seat_index)
	creature.turn_towards(seat)
	var hop = 0.0
	while hop < 1.0:
		await get_tree().process_frame
		if !is_instance_valid(node) or !node.is_inside_tree():
			return
		hop = min(1.0, hop + get_process_delta_time() / 0.35)
		node.global_position = start.lerp(seat, hop)
		sprite.lift = int(round(lerp(0.0, float(SEAT_HEIGHT), hop) + sin(hop * PI) * 6.0))
	sit_down(node, seat_index)

# y 排序按节点原点比较：把朋友的原点放在凳子原点之下，造型再挪回座位，保证画在凳面上。
func sit_down(node, seat_index, instant = false):
	var creature = node.get_node("InteractableCreature")
	var sprite = creature.get_node("StackedSprite")
	var seat = seat_global(seat_index)
	node.global_position = seat + Vector2(0, 1)
	creature.position.y = seat.y - node.global_position.y
	sprite.lift = SEAT_HEIGHT
	sprite.shadow_radius = 0
	creature.bubble_offset = creature.bubble_offset + Vector2(0, -SEAT_HEIGHT)
	creature.turn_towards(aisle_point(seat_index))
	if instant:
		creature.current_rotation = creature.next_rotation
	set_blocking(creature, true)

func set_blocking(creature, blocking):
	creature.get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", !blocking)
