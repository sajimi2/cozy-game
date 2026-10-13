extends Node2D

@export var symbols: Array[Texture2D] = []
# 第一次交互前用加大的气泡，Z 键和空格键轮流按下，告诉玩家用哪个键。
@export var wide_bubble: Texture2D = null
const KEY_SYMBOL_FRAMES = 8

func _ready():
	if Globals.has_completed_sign:
		$InteractableCreature.symbol = symbols[1]
	else:
		$InteractableCreature.symbol = symbols[0]
		$InteractableCreature/Interactable.set_bubble_texture(wide_bubble, KEY_SYMBOL_FRAMES)

func _on_InteractableCreature_interacted(body):
	AudioManager.play_sfx("HeartAppears")
	if !Globals.has_completed_sign:
		$InteractableCreature.symbol = symbols[1]
		$InteractableCreature/Interactable.set_bubble_texture(null)
		Globals.has_completed_sign = true

func _on_InteractableCreature_entered():
	pass # Replace with function body.
