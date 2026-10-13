extends CanvasLayer

const ENDING := preload("res://art/ui/ending_gathering.png")
const ORIGINAL_CREDITS := preload("res://sprites/minigames/Credits.png")
var _opened_at := 0
var _was_paused := false
var _showing_original := false
var _closing := false

func _ready() -> void:
	$Root.hide()

func is_open() -> bool:
	return $Root.visible

func open() -> void:
	if is_open():
		return
	_was_paused = get_tree().paused
	_opened_at = Time.get_ticks_msec()
	_closing = false
	_showing_original = false
	_show_ending()
	IllustratedDisplay.use_illustration(get_window())
	$Root.show()
	# 暂停玩法，画页自身继续处理按钮，防止读图时移动或重复触发书架。
	get_tree().paused = true
	$Root/Close.grab_focus()

func _show_ending() -> void:
	$Root/Image.texture = ENDING
	$Root/Image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	$Root/CreditsButton.text = "原作致谢"
	$Root/Caption.text = "大家都在这里。"

func _on_credits_pressed() -> void:
	_showing_original = not _showing_original
	if _showing_original:
		$Root/Image.texture = ORIGINAL_CREDITS
		$Root/Image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		$Root/CreditsButton.text = "回到合照"
		$Root/Caption.text = "原作：Jon Topielski 与 Mellorine"
	else:
		_show_ending()

func _on_close_pressed() -> void:
	if _closing or not is_open():
		return
	_closing = true
	# 关闭键松开后才恢复场景，避免关闭输入同时触发书架或小游戏。
	while Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_cancel"):
		await get_tree().process_frame
	$Root.hide()
	IllustratedDisplay.use_game(get_window())
	get_tree().paused = _was_paused
	_closing = false
	get_tree().call_group("barn_area", "_on_ending_gallery_closed")

func _unhandled_key_input(event: InputEvent) -> void:
	if not is_open() or Time.get_ticks_msec() - _opened_at < 250:
		return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_close_pressed()
