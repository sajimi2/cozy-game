extends Node2D

@export var symbols = [] # (Array, Texture2D)
# 第一次交互前用加宽的气泡，画出 Z 键和空格键被按下，告诉玩家用哪个键。
@export var wide_bubble: Texture2D = null

func _ready():
	if Globals.has_completed_sign:
		$InteractableCreature.symbol = symbols[1]
	else:
		$InteractableCreature.symbol = symbols[0]
		$InteractableCreature/Interactable.set_bubble_texture(wide_bubble)

func _on_InteractableCreature_interacted(body):
	AudioManager.play_sfx("HeartAppears")
	if !Globals.has_completed_sign:
		$InteractableCreature.symbol = symbols[1]
		$InteractableCreature/Interactable.set_bubble_texture(null)
		Globals.has_completed_sign = true

func _on_InteractableCreature_entered():
	pass # Replace with function body.
