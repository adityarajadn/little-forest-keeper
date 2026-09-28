extends CharacterBody2D
class_name ForestFox

@export var move_speed: float = 65.0

@onready var sprite: Sprite2D = $Sprite2D

var anim_timer: float = 0.0
var state_timer: float = 0.0
var facing_dir: int = 1
var is_walking: bool = false

func _ready() -> void:
	add_to_group("foxes")
	_pick_wander()

func _physics_process(delta: float) -> void:
	state_timer -= delta
	anim_timer += delta * 7.0
	
	if state_timer <= 0.0:
		_pick_wander()
		
	move_and_slide()
	
	if velocity.length() > 5.0:
		is_walking = true
		if velocity.x > 3.0:
			facing_dir = 1
		elif velocity.x < -3.0:
			facing_dir = -1
	else:
		is_walking = false
		
	if sprite:
		sprite.flip_h = (facing_dir < 0)
		if is_walking:
			sprite.frame = 2 + (int(anim_timer) % 4)
		else:
			sprite.frame = int(anim_timer * 0.4) % 2

func _pick_wander() -> void:
	state_timer = randf_range(2.0, 5.0)
	if randf() < 0.5:
		velocity = Vector2.ZERO
	else:
		var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = dir * move_speed
