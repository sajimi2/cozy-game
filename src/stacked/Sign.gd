extends StaticBody2D

func _ready():
	randomize()
	$Node2D/StackedSprite.rotate_sprites(deg_to_rad(-10))

func _on_Interactable_interacted(body):
	$Node2D/Interactable.set_active()

func _on_Interactable_entered():
	pass

func _on_Interactable_exited():
	pass
