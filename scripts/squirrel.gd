extends CharacterBody2D
class_name Squirrel

enum State { WANDER, SEEK_ACORN, CARRYING_ACORN, PLANTING }

@export var move_speed: float = 70.0

@onready var sprite: Sprite2D = $Sprite2D

var current_state: State = State.WANDER
var target_acorn: Node2D = null
var plant_target_pos: Vector2 = Vector2.ZERO
var state_timer: float = 0.0
var anim_timer: float = 0.0
var facing_dir: int = 1

func _ready() -> void:
	add_to_group("squirrels")
	_pick_random_wander()

func _physics_process(delta: float) -> void:
	anim_timer += delta * 9.0
	state_timer -= delta
	
	match current_state:
		State.WANDER:
			_process_wander(delta)
			_check_for_acorns()
			
		State.SEEK_ACORN:
			_process_seek_acorn(delta)
			
		State.CARRYING_ACORN:
			_process_carry_acorn(delta)
			
		State.PLANTING:
			velocity = Vector2.ZERO
			if state_timer <= 0.0:
				_finish_planting()
	
	move_and_slide()
	if velocity.x > 3.0:
		facing_dir = 1
	elif velocity.x < -3.0:
		facing_dir = -1
		
	if sprite:
		sprite.flip_h = (facing_dir < 0)
		match current_state:
			State.WANDER:
				if velocity.length() > 5.0:
					sprite.frame = 2 + (int(anim_timer) % 4)
				else:
					sprite.frame = int(anim_timer * 0.4) % 2
			State.SEEK_ACORN:
				sprite.frame = 2 + (int(anim_timer) % 4)
			State.CARRYING_ACORN:
				sprite.frame = 6
			State.PLANTING:
				sprite.frame = 6 + (int(anim_timer) % 2)

func _check_for_acorns() -> void:
	var acorns = get_tree().get_nodes_in_group("acorns")
	var closest: Node2D = null
	var min_dist: float = 99999.0
	for a in acorns:
		if is_instance_valid(a) and not a.is_claimed:
			var d = global_position.distance_to(a.global_position)
			if d < min_dist:
				min_dist = d
				closest = a
	
	if closest and closest.claim():
		target_acorn = closest
		current_state = State.SEEK_ACORN

func _process_wander(_delta: float) -> void:
	if state_timer <= 0.0:
		_pick_random_wander()

func _pick_random_wander() -> void:
	state_timer = randf_range(1.5, 3.5)
	if randf() < 0.4:
		velocity = Vector2.ZERO
	else:
		var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = dir * (move_speed * 0.6)

func _process_seek_acorn(_delta: float) -> void:
	if not is_instance_valid(target_acorn):
		current_state = State.WANDER
		_pick_random_wander()
		return
	
	var dir = (target_acorn.global_position - global_position).normalized()
	velocity = dir * move_speed
	
	if global_position.distance_to(target_acorn.global_position) < 14.0:
		target_acorn.queue_free()
		target_acorn = null
		current_state = State.CARRYING_ACORN
		var angle = randf() * TAU
		plant_target_pos = global_position + Vector2(cos(angle), sin(angle)) * randf_range(40.0, 90.0)
		plant_target_pos.x = clamp(plant_target_pos.x, 80.0, 1200.0)
		plant_target_pos.y = clamp(plant_target_pos.y, 80.0, 640.0)

func _process_carry_acorn(_delta: float) -> void:
	var dir = (plant_target_pos - global_position).normalized()
	velocity = dir * (move_speed * 0.8)
	
	if global_position.distance_to(plant_target_pos) < 12.0:
		velocity = Vector2.ZERO
		current_state = State.PLANTING
		state_timer = 1.2

func _finish_planting() -> void:
	var gm = get_node_or_null("/root/Main/GameManager")
	var parent_node = get_parent()
	if parent_node and gm:
		var plant = gm.plant_scene.instantiate()
		plant.position = global_position
		parent_node.add_child(plant)
		gm.add_health(1.5)
		gm.emit_signal("status_message", "The Squirrel has planted a new seeds!")
	
	current_state = State.WANDER
	_pick_random_wander()
