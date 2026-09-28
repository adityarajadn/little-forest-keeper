extends Node2D
class_name ForestLeaves

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("leaves_ground")
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	scale = Vector2.ZERO
	rotation = randf_range(-0.5, 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
