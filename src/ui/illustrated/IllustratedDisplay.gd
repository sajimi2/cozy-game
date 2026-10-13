class_name IllustratedDisplay
extends RefCounted

const UI_SIZE := Vector2i(768, 576)
const GAME_SIZE := Vector2i(192, 144)

# 插画与文字在窗口分辨率绘制，回到游戏时恢复原有像素整数缩放。
static func use_illustration(window: Window) -> void:
	window.content_scale_size = UI_SIZE
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL

static func use_game(window: Window) -> void:
	window.content_scale_size = GAME_SIZE
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
