extends Node2D
class_name ForestNest

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("nests")
	add_to_group("shelters")
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
