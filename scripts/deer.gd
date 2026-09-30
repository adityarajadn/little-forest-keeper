extends CharacterBody2D
class_name ForestDeer

enum State { WANDER, WALK_TO_WATER, IDLE }

@export var move_speed: float = 50.0
@onready var sprite: Sprite2D = $Sprite2D

var current_state: State = State.WANDER
var state_timer: float = 0.0
var anim_timer: float = 0.0
var facing_dir: int = 1
var target_water: Node2D = null

func _ready() -> void:
	add_to_group("deer")
	_pick_random_wander()

func _physics_process(delta: float) -> void:
	anim_timer += delta * 5.0
	state_timer -= delta
	
	match current_state:
		State.WANDER:
			_process_wander(delta)
			_check_for_water()
		State.WALK_TO_WATER:
			_process_walk_to_water(delta)
		State.IDLE:
			velocity = Vector2.ZERO
			if state_timer <= 0.0:
				current_state = State.WANDER
				_pick_random_wander()
				
	move_and_slide()
	if velocity.x > 3.0:
		facing_dir = 1
	elif velocity.x < -3.0:
		facing_dir = -1
		
	if sprite:
		sprite.flip_h = (facing_dir < 0)
		if velocity.length() > 5.0:
			sprite.frame = 2 + (int(anim_timer) % 4)
		else:
			sprite.frame = int(anim_timer * 0.3) % 2

func _process_wander(_delta: float) -> void:
	if state_timer <= 0.0:
		_pick_random_wander()

func _pick_random_wander() -> void:
	state_timer = randf_range(3.0, 6.0)
	if randf() < 0.6:
		velocity = Vector2.ZERO
	else:
		var angle = randf() * TAU
		velocity = Vector2(cos(angle), sin(angle)) * move_speed

func _check_for_water() -> void:
	var waters = get_tree().get_nodes_in_group("water")
	if waters.size() > 0 and randf() < 0.01:
		target_water = waters[randi() % waters.size()]
		current_state = State.WALK_TO_WATER

func _process_walk_to_water(_delta: float) -> void:
	if not is_instance_valid(target_water):
		current_state = State.WANDER
		_pick_random_wander()
		return

	var direction := global_position.direction_to(target_water.global_position)
	velocity = direction * move_speed

	if global_position.distance_to(target_water.global_position) < 20.0:
		velocity = Vector2.ZERO
		current_state = State.IDLE
		state_timer = randf_range(3.0, 6.0)
