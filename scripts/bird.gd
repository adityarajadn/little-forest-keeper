extends CharacterBody2D
class_name Bird

enum State { WANDER, FLY_TO_NEST, IDLE }

@export var move_speed: float = 90.0
@onready var sprite: Sprite2D = $Sprite2D

var current_state: State = State.WANDER
var state_timer: float = 0.0
var anim_timer: float = 0.0
var facing_dir: int = 1

var target_nest: Node2D = null

func _ready() -> void:
	add_to_group("birds")
	_pick_random_wander()

func _physics_process(delta: float) -> void:
	anim_timer += delta * 8.0
	state_timer -= delta
	
	match current_state:
		State.WANDER:
			_process_wander(delta)
			_check_for_nests()
		State.FLY_TO_NEST:
			_process_fly(delta)
		State.IDLE:
			velocity = Vector2.ZERO
			if state_timer <= 0.0:
				current_state = State.WANDER
				_pick_random_wander()
				
	move_and_slide()
	if velocity.x > 2.0:
		facing_dir = 1
	elif velocity.x < -2.0:
		facing_dir = -1
		
	if sprite:
		sprite.flip_h = (facing_dir < 0)
		if velocity.length() > 5.0:
			sprite.frame = 2 + (int(anim_timer) % 2)
		else:
			sprite.frame = int(anim_timer * 0.3) % 2

func _process_wander(_delta: float) -> void:
	if state_timer <= 0.0:
		_pick_random_wander()

func _pick_random_wander() -> void:
	state_timer = randf_range(2.0, 4.0)
	if randf() < 0.3:
		velocity = Vector2.ZERO
	else:
		var angle = randf() * TAU
		velocity = Vector2(cos(angle), sin(angle)) * move_speed

func _check_for_nests() -> void:
	var nest = get_tree().get_nodes_in_group("nests")

	if nest.size() > 0 and randf() < 0.01:
		var target = nest[randi() % nest.size()]

		if is_instance_valid(target):
			target_nest = target
			current_state = State.FLY_TO_NEST

func _process_fly(_delta: float) -> void:
	if not is_instance_valid(target_nest):
		current_state = State.WANDER
		_pick_random_wander()
		return

	var target_position := target_nest.global_position + Vector2(0, -30)
	var direction := global_position.direction_to(target_position)

	velocity = direction * move_speed

	if global_position.distance_to(target_position) < 10.0:
		global_position = target_position
		velocity = Vector2.ZERO

		current_state = State.IDLE
		state_timer = randf_range(3.0, 6.0)
