extends Node2D
class_name Acorn

@onready var sprite: Sprite2D = $Sprite2D

var is_claimed: bool = false
var anim_timer: float = 0.0

func _ready() -> void:
	add_to_group("acorns")
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2.ONE, 0.35)

func _process(delta: float) -> void:
	anim_timer += delta * 4.0
	if sprite and sprite.hframes > 1:
		sprite.frame = int(anim_timer) % sprite.hframes

func claim() -> bool:
	if is_claimed:
		return false
	is_claimed = true
	return true
