extends CharacterBody2D
class_name ForestRabbit

enum State { HOP, IDLE_NIBBLE }

@export var move_speed: float = 55.0

@onready var sprite: Sprite2D = $Sprite2D

var current_state: State = State.IDLE_NIBBLE
var state_timer: float = 2.0
var anim_timer: float = 0.0
var facing_dir: int = 1

func _ready() -> void:
	add_to_group("rabbits")
	_pick_action()

func _physics_process(delta: float) -> void:
	anim_timer += delta * 8.0
	state_timer -= delta
	
	if state_timer <= 0.0:
		_pick_action()
		
	move_and_slide()
	if velocity.x > 3.0:
		facing_dir = 1
	elif velocity.x < -3.0:
		facing_dir = -1
		
	if sprite:
		sprite.flip_h = (facing_dir < 0)
		if current_state == State.HOP and velocity.length() > 5.0:
			sprite.frame = 2 + (int(anim_timer) % 4)
		else:
			sprite.frame = int(anim_timer * 0.3) % 2

func _pick_action() -> void:
	if randf() < 0.45:
		current_state = State.IDLE_NIBBLE
		velocity = Vector2.ZERO
		state_timer = randf_range(2.0, 4.0)
	else:
		current_state = State.HOP
		state_timer = randf_range(1.5, 3.0)
		var plants = get_tree().get_nodes_in_group("plants")
		if plants.size() > 0 and randf() < 0.7:
			var target = plants.pick_random()
			var dir = (target.global_position - global_position).normalized()
			velocity = dir * move_speed
		else:
			var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			velocity = dir * move_speed
