extends Node2D
class_name ForestPlant

enum Stage { SEED, SPROUT, BUSH, TREE }

@export var stage: Stage = Stage.SEED

@onready var sprite: Sprite2D = $Sprite2D

var growth_progress: float = 0.0
var time_to_grow: float = 14.0
var is_watered: bool = false
var sway_time: float = 0.0
var drop_timer: float = 0.0

func _ready() -> void:
	add_to_group("plants")
	_update_water_status()
	_update_sprite()
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)

func _process(delta: float) -> void:
	sway_time += delta * 2.0
	_update_water_status()
	
	if stage < Stage.TREE:
		var speed_mult = 1.8 if is_watered else 0.8
		growth_progress += delta * speed_mult
		if growth_progress >= time_to_grow:
			advance_stage()
	else:
		# Mature tree naturally sheds autumn gifts (acorns, leaves, branches)
		drop_timer += delta
		if drop_timer >= 22.0:
			drop_timer = randf_range(0.0, 6.0)
			_drop_forest_resource()
			
	if sprite:
		var sway_rot = sin(sway_time) * 0.05 if stage >= Stage.SPROUT else 0.0
		sprite.rotation = sway_rot

func _update_water_status() -> void:
	var waters = get_tree().get_nodes_in_group("water")
	is_watered = false
	for w in waters:
		if global_position.distance_to(w.global_position) < 90.0:
			is_watered = true
			break

func boost_growth(amount: float) -> void:
	growth_progress += amount

func advance_stage() -> void:
	growth_progress = 0.0
	stage = Stage.values()[min(stage + 1, Stage.TREE)]
	_update_sprite()
	
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	scale = Vector2(0.8, 1.3)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)
	
	var gm = get_node_or_null("/root/Main/GameManager")
	if gm:
		gm.add_health(1.5)

func _drop_forest_resource() -> void:
	var gm = get_node_or_null("/root/Main/GameManager")
	var parent_node = get_parent()
	if not gm or not parent_node:
		return
	
	var offset = Vector2(randi_range(-1, 1) * gm.GRID_SIZE, randi_range(-1, 1) * gm.GRID_SIZE)
	var drop_pos = (global_position + offset).snapped(Vector2.ONE * gm.GRID_SIZE) + Vector2(gm.GRID_SIZE/2, gm.GRID_SIZE/2)
	
	var roll = randf()
	if roll < 0.40:
		var ac = gm.acorn_scene.instantiate()
		ac.position = drop_pos
		parent_node.add_child(ac)
	elif roll < 0.70:
		var lf = gm.leaves_scene.instantiate()
		lf.position = drop_pos
		parent_node.add_child(lf)
	else:
		var br = gm.branch_scene.instantiate()
		br.position = drop_pos
		parent_node.add_child(br)

func _update_sprite() -> void:
	if sprite:
		sprite.frame = int(stage)
