extends StaticBody2D

@export var angle: float = 0.0: set = set_angle

func set_angle(_angle):
	angle = _angle
	if find_child("StackedSprite"):
		$StackedSprite.rotate_sprites(deg_to_rad(angle))
		$CollisionShape2D.rotation_degrees = _angle + 90

func _ready():
	set_angle(angle)
