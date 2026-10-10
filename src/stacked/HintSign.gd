extends Node2D

@export var symbols = [] # (Array, Texture2D)

func _ready():
	$InteractableCreature.symbol = symbols[7]

func _on_InteractableCreature_interacted(body):
	$InteractableCreature.symbol = symbols[Globals.get_progress_level()]
	AudioManager.play_sfx("SignShowsProgressHeart")

func _on_InteractableCreature_exited():
	$InteractableCreature.symbol = symbols[7]

func _on_InteractableCreature_entered():
	AudioManager.play_sfx("QuestionMarkAppears")
