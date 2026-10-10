extends Node2D

const HintText = preload("res://src/ui/HintText.gd")

@export var symbols = [] # (Array, Texture2D)

func _ready():
	if Globals.has_found_egg:
		queue_free()
	else:
		$InteractableCreature.symbol = symbols[0]

func _on_InteractableCreature_interacted(body):
	Globals.has_found_egg = true
	$DormantEgg.show()
	$InteractableCreature.hide()
	TextBox.show_hint(HintText.EGG_PICKED, get_tree().current_scene, false, 4.0)
	$AnimationPlayer.play("shrink")
	AudioManager.play_sfx("PickupEgg")
	await $AnimationPlayer.animation_finished
	queue_free()

func get_hint():
	return HintText.EGG
