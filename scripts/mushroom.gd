extends Node2D
class_name ForestMushroom

@onready var sprite: Sprite2D = $Sprite2D

var anim_timer: float = 0.0

func _ready() -> void:
	add_to_group("mushrooms")
	AudioManager.play_sfx(preload("res://assets/audio/Item Pop.wav"))
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)

func _process(delta: float) -> void:
	anim_timer += delta * 2.5
	if sprite and sprite.hframes > 1:
		sprite.frame = int(anim_timer) % sprite.hframes
