extends CanvasLayer

var hand_tween: Tween

signal won
signal lost
signal canceled

const ChatBubble = preload("res://sprites/ui/ChatBubble.png")

# 猜错时揭晓答案的方式：小羊气泡里的格子就是线索。
# 1 = 先亮出小羊的格子气泡，再变成数字；2 = 格子一格一格亮起来，数完再变成数字。
var clue_symbol: Texture2D = null
var hint_level = 0

var current_number = 0
var enemy_number = 0

var has_selected_number = false

func _ready():
	AudioManager.play_song("MinigameMusic")
	AudioManager.play_sfx("StartedMinigame")
	get_tree().paused = true
	$Question.frame = 0
	$Question/Shadow.frame = 0
	$Hand.frame = 0
	$Hand/Shadow.frame = 0
	move_hand_to_number(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_left") and !has_selected_number:
		current_number -= 1
		if current_number == -1:
			current_number = 9
		move_hand_to_number()
	if Input.is_action_just_pressed("ui_right") and !has_selected_number:
		current_number += 1
		if current_number == 10:
			current_number = 0
		move_hand_to_number()
	if Input.is_action_just_pressed("ui_accept") and $InputLagTimer.is_stopped() and !has_selected_number:
		has_selected_number = true
		AudioManager.play_sfx("SelectOptionUsingHand")
		for child in get_children():
			if "Number" in child.name and !str(current_number) in child.name:
				child.hide()
		$Hand.hide()
		await get_tree().create_timer(1.0).timeout
		$Question.hide()
		if enemy_number != current_number and clue_symbol and hint_level > 0:
			await show_clue()
		var enemy_number_object = find_child("Number_%s" % str(enemy_number)).duplicate()
		add_child(enemy_number_object)
		enemy_number_object.position = $Question.position
		enemy_number_object.show()
		var did_player_win = false
		if enemy_number == current_number:
			did_player_win = true
			AudioManager.play_sfx("RightAnswer")
			enemy_number_object.self_modulate = Color.GREEN.lightened(0.25)
		else:
			AudioManager.play_sfx("WrongAnswer")
			enemy_number_object.self_modulate = Color.RED.lightened(0.25)
		for i in range(0, 8):
			enemy_number_object.visible = !enemy_number_object.visible
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(1.5).timeout
		if did_player_win:
			emit_signal("won")
		else:
			emit_signal("lost")
		get_tree().paused = false
		queue_free()
	if Input.is_action_just_pressed("ui_cancel"):
		AudioManager.play_sfx("CanceledMinigame")
		emit_signal("canceled")
		get_tree().paused = false
		queue_free()

func show_clue():
	var bubble = AnimatedSprite2D.new()
	bubble.sprite_frames = make_bubble_frames()
	bubble.position = $Question.position
	add_child(bubble)
	var symbol = Sprite2D.new()
	symbol.hframes = 4
	bubble.add_child(symbol)
	bubble.frame_changed.connect(func(): symbol.frame = bubble.frame)
	bubble.play("default")
	if hint_level >= 2:
		for count in range(0, enemy_number + 1):
			symbol.texture = partial_grid(clue_symbol, count)
			if count > 0:
				AudioManager.play_sfx("ChangeOptionUsingHand")
			await get_tree().create_timer(0.3).timeout
		await get_tree().create_timer(0.5).timeout
	else:
		symbol.texture = clue_symbol
		AudioManager.play_sfx("QuestionMarkAppears")
		await get_tree().create_timer(1.2).timeout
	bubble.queue_free()

func make_bubble_frames():
	var frames = SpriteFrames.new()
	frames.set_animation_speed("default", 5.0)
	var frame_width = ChatBubble.get_width() / 4
	for i in 4:
		var region = AtlasTexture.new()
		region.atlas = ChatBubble
		region.region = Rect2(i * frame_width, 0, frame_width, ChatBubble.get_height())
		frames.add_frame("default", region)
	return frames

# 只保留格子图里按阅读顺序的前 count 个红格（格子图共 4 帧，每帧 8x8，3x3 个 2x2 的格）。
func partial_grid(texture, count):
	var image = texture.get_image()
	image.decompress()
	for frame in 4:
		var origin = frame * 8
		var line_rows = []
		for y in 8:
			var full = true
			for x in 8:
				if image.get_pixel(origin + x, y).a == 0.0:
					full = false
			if full:
				line_rows.push_back(y)
		var red = []
		for y in 8:
			for x in 8:
				var c = image.get_pixel(origin + x, y)
				if c.a > 0.0 and c.r > 0.55 and c.g < 0.4:
					var row = line_rows.filter(func(line): return line < y).size()
					red.push_back([row * 3 + x / 3, x, y])
		var cells = []
		for pixel in red:
			if !cells.has(pixel[0]):
				cells.push_back(pixel[0])
		cells.sort()
		for pixel in red:
			if cells.find(pixel[0]) >= count:
				image.set_pixel(origin + pixel[1], pixel[2], Color(0, 0, 0, 0))
	return ImageTexture.create_from_image(image)

func move_hand_to_number(play_sound = true):
	if play_sound:
		AudioManager.play_sfx("ChangeOptionUsingHand")
	for child in get_children():
		if "Number" in child.name:
			child.self_modulate = Color.WHITE
	var number_ref = find_child("Number_%d" % current_number)
	number_ref.self_modulate = Color("e3d588")
	if hand_tween:
		hand_tween.kill()
	hand_tween = create_tween()
	hand_tween.tween_property($Hand, "position", number_ref.position - Vector2(0, 20), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func _on_Hand_frame_changed():
	for child in get_children():
		if "Number" in child.name:
			child.frame = $Hand.frame
			child.get_child(0).frame = $Hand.frame

func _on_InputLagTimer_timeout():
	pass # Replace with function body.
