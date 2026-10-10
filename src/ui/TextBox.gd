extends CanvasLayer

# 不打断操作的中文提示条。靠近角色、进入小游戏或第一次进入区域时显示。
# source 是提示的“主人”：只有同一个主人能把它收起，主人被释放（如切换场景）时自动收起。

const MARGIN = 5
const PADDING_X = 5
const PADDING_Y = 3
const CHARACTERS_PER_SECOND = 45.0

var current_source = null
var current_text = ""
var visible_amount = 0.0
var hide_countdown = 0.0

@onready var panel = $Panel
@onready var label = $Panel/Label

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.hide()

func show_hint(text, source = null, at_top = false, duration = 0.0):
	if text == "":
		hide_hint(source)
		return
	hide_countdown = duration
	if panel.visible and text == current_text and source == current_source:
		return
	current_source = source
	current_text = text
	label.text = text
	label.visible_characters = 0
	visible_amount = 0.0
	layout_panel(at_top)
	panel.show()

func hide_hint(source = null):
	if source != null and source != current_source:
		return
	current_source = null
	current_text = ""
	panel.hide()

func is_showing(source):
	return panel.visible and current_source == source

func layout_panel(at_top):
	var screen_size = get_viewport().get_visible_rect().size
	var width = screen_size.x - MARGIN * 2
	label.position = Vector2(PADDING_X, PADDING_Y)
	label.size = Vector2(width - PADDING_X * 2, 0)
	var height = label.get_line_count() * label.get_line_height() + PADDING_Y * 2
	panel.size = Vector2(width, height)
	panel.position.x = MARGIN
	panel.position.y = MARGIN if at_top else screen_size.y - MARGIN - height

func _process(delta):
	if !panel.visible:
		return
	if current_source != null and (!is_instance_valid(current_source) or !current_source.is_inside_tree()):
		hide_hint()
		return
	if label.visible_characters != -1:
		visible_amount += delta * CHARACTERS_PER_SECOND
		label.visible_characters = int(visible_amount)
		if label.visible_characters >= label.get_total_character_count():
			label.visible_characters = -1
	if hide_countdown > 0.0:
		hide_countdown -= delta
		if hide_countdown <= 0.0:
			hide_hint()
