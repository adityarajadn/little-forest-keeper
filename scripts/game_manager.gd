extends Node
class_name GameManager

signal health_changed(new_health: float, old_health: float)
signal inventory_changed()
signal species_discovered(species_name: String)
signal status_message(text: String)
signal day_changed(new_day: int)
signal day_time_updated(day_progress: float) # 0.0 to 1.0 (morning -> noon -> dusk -> night)


var current_day: int = 1
var day_timer: float = 0.0
@export var day_duration: float = 70.0 # 70 seconds per in-game day (balanced autumn progression)

var total_nest: int = 0

var forest_health: float = 5.0
var inventory: Dictionary = {
	"acorn": 6,
	"water": 4,
	"mushroom": 3,
	"leaves": 5,
	"branch": 4
}

var selected_resource: String = "acorn"
var discovered_species: Array[String] = []

var plant_scene: PackedScene = preload("res://scenes/entities/plant.tscn")
var squirrel_scene: PackedScene = preload("res://scenes/entities/squirrel.tscn")
var bird_scene: PackedScene = preload("res://scenes/entities/bird.tscn")
var rabbit_scene: PackedScene = preload("res://scenes/entities/rabbit.tscn")
var fox_scene: PackedScene = preload("res://scenes/entities/fox.tscn")
var deer_scene: PackedScene = preload("res://scenes/entities/deer.tscn")
var acorn_scene: PackedScene = preload("res://scenes/entities/acorn.tscn")
var water_scene: PackedScene = preload("res://scenes/entities/water.tscn")
var mushroom_scene: PackedScene = preload("res://scenes/entities/mushroom.tscn")
var branch_scene: PackedScene = preload("res://scenes/entities/branch.tscn")
var leaves_scene: PackedScene = preload("res://scenes/entities/leaves.tscn")
var nest_scene: PackedScene = preload("res://scenes/entities/nest.tscn")

var squirrel_spawn_cooldown: float = 0.0
var rabbit_spawn_cooldown: float = 0.0
var fox_spawn_cooldown: float = 0.0
var deer_spawn_cooldown: float = 0.0
var bird_spawn_cooldown: float = 0.0
var resource_spawn_timer: float = 8.0


func _ready() -> void:
	AudioManager.play_music(preload("res://assets/audio/Autumn BGM.wav"))
	emit_signal("health_changed", forest_health, 0.0)
	emit_signal("inventory_changed")
	emit_signal("day_changed", current_day)
	emit_signal("day_time_updated", 0.0)


func _process(delta: float) -> void:
	# Advance day-night cycle
	day_timer += delta
	
	if day_timer >= day_duration:
		day_timer = fmod(day_timer, day_duration)
		current_day += 1
		emit_signal("day_changed", current_day)
		emit_signal("status_message", "New day: Autumn Day %d! Morning breeze brings natural resources to the forest." % current_day)
		_spawn_morning_windfall()
	
	var progress = day_timer / day_duration
	emit_signal("day_time_updated", progress)
	_update_ambient_light(progress)

	squirrel_spawn_cooldown = max(0.0, squirrel_spawn_cooldown - delta)
	rabbit_spawn_cooldown = max(0.0, rabbit_spawn_cooldown - delta)
	fox_spawn_cooldown = max(0.0, fox_spawn_cooldown - delta)
	deer_spawn_cooldown = max(0.0, deer_spawn_cooldown - delta)
	
	resource_spawn_timer -= delta
	
	if resource_spawn_timer <= 0.0:
		_spawn_natural_resources()
		resource_spawn_timer = randf_range(8.0, 14.0)
		
	_evaluate_ecosystem(delta)


func select_resource(res_name: String) -> void:
	if inventory.has(res_name):
		selected_resource = res_name
		emit_signal("inventory_changed")


func use_selected_resource(world_pos: Vector2, parent_node: Node) -> bool:
	if inventory.get(selected_resource, 0) <= 0:
		emit_signal("status_message", "Out of stock! Approach the resource and press [E] to collect it from the forest.")
		return false
	
	inventory[selected_resource] -= 1
	emit_signal("inventory_changed")
	
	match selected_resource:
		"acorn":
			var acorn = acorn_scene.instantiate()
			acorn.position = world_pos
			parent_node.add_child(acorn)
			emit_signal("status_message", "Placed an Acorn on the ground!")
		
		"water":
			var water = water_scene.instantiate()
			water.position = world_pos
			parent_node.add_child(water)
			emit_signal("status_message", "Fresh water is flowing!")
			add_health(1.5)
		
		"mushroom":
			var shroom = mushroom_scene.instantiate()
			shroom.position = world_pos
			parent_node.add_child(shroom)
			emit_signal("status_message", "A mushroom grows and enriches the soil!")
			add_health(1.0)
		
		"leaves":
			# Check if there is an existing branch nearby on the ground.
			# If so, combine them into a Nest!
			var nearby_branch = _find_nearby_node(world_pos, "branches", 48.0)
			
			if nearby_branch:
				nearby_branch.queue_free()
				
				var nest = nest_scene.instantiate()
				nest.position = (world_pos + nearby_branch.global_position) / 2.0
				parent_node.add_child(nest)
				total_nest += 1
				
				emit_signal("status_message", "Leaves + Branch combine to create a Nest!")
				add_health(3.5)
			else:
				var leaf_node = leaves_scene.instantiate()
				leaf_node.position = world_pos
				parent_node.add_child(leaf_node)
				
				emit_signal("status_message", "Fallen leaves enrich the surrounding area!")
				add_health(0.5)
				
				var plants = parent_node.get_tree().get_nodes_in_group("plants")
				
				for p in plants:
					if p.global_position.distance_to(world_pos) < 120.0:
						p.boost_growth(3.0)
		
		"branch":
			# Check if there are existing leaves on the ground nearby.
			# If so, combine them into a Nest!
			var nearby_leaf = _find_nearby_node(world_pos, "leaves_ground", 48.0)
			
			if nearby_leaf:
				nearby_leaf.queue_free()
				
				var nest = nest_scene.instantiate()
				nest.position = (world_pos + nearby_leaf.global_position) / 2.0
				parent_node.add_child(nest)
				
				emit_signal("status_message", "Branch + Leaves combine to create a Nest!")
				add_health(3.5)
				total_nest += 1
			else:
				var branch_node = branch_scene.instantiate()
				branch_node.position = world_pos
				parent_node.add_child(branch_node)
		
	emit_signal("status_message", "🪵 Placed a wooden branch!")
	add_health(0.5)
	
	return true


func _find_nearby_node(pos: Vector2, group_name: String, radius: float) -> Node2D:
	var nodes = get_tree().get_nodes_in_group(group_name)
	
	for n in nodes:
		if n is Node2D and is_instance_valid(n) and not n.is_queued_for_deletion():
			if n.global_position.distance_to(pos) <= radius:
				return n
	
	return null


func _update_ambient_light(progress: float) -> void:
	var mod_node = get_node_or_null("../DayNightModulate")
	
	if not mod_node or not (mod_node is CanvasModulate):
		return
	
	# 0.0 - 0.2: Dawn / Warm morning light
	# 0.2 - 0.6: Bright autumn daytime
	# 0.6 - 0.8: Soft golden-orange dusk
	# 0.8 - 1.0: Cozy starry night
	var target_col: Color
	
	if progress < 0.2:
		var t = progress / 0.2
		target_col = Color(0.75, 0.77, 0.90).lerp(Color(0.98, 0.92, 0.85), t)
	
	elif progress < 0.65:
		var t = (progress - 0.2) / 0.45
		target_col = Color(0.98, 0.92, 0.85).lerp(Color(1.0, 0.98, 0.95), t)
	
	elif progress < 0.85:
		var t = (progress - 0.65) / 0.20
		target_col = Color(1.0, 0.98, 0.95).lerp(Color(0.96, 0.80, 0.68), t)
	
	else:
		var t = (progress - 0.85) / 0.15
		target_col = Color(0.96, 0.80, 0.68).lerp(Color(0.75, 0.77, 0.90), t)
		
	mod_node.color = target_col


func _spawn_natural_resources() -> void:
	var tree_root = get_tree()
	
	if not tree_root or not tree_root.current_scene:
		return
	
	var world_layer = tree_root.current_scene.get_node_or_null("WorldObjects")
	
	if not world_layer:
		world_layer = tree_root.current_scene
		
	var pos = Vector2(
		randf_range(80, 1200),
		randf_range(80, 640)
	)
	
	var choice = randf()
	
	if choice < 0.30:
		var ac = acorn_scene.instantiate()
		ac.position = pos
		world_layer.add_child(ac)
	elif choice < 0.55:
		var br = branch_scene.instantiate()
		br.position = pos
		world_layer.add_child(br)
	elif choice < 0.80:
		var lf = leaves_scene.instantiate()
		lf.position = pos
		world_layer.add_child(lf)
	else:
		var ms = mushroom_scene.instantiate()
		ms.position = pos
		world_layer.add_child(ms)


func _spawn_morning_windfall() -> void:
	var tree_root = get_tree()
	if not tree_root or not tree_root.current_scene:
		return
	var world_layer = tree_root.current_scene.get_node_or_null("WorldObjects")
	if not world_layer:
		world_layer = tree_root.current_scene

	# Spawn 3-4 natural items across the forest every morning
	var count = randi_range(3, 4)
	for i in range(count):
		var pos = Vector2(randf_range(90, 1180), randf_range(90, 630))
		var roll = randf()
		if roll < 0.30:
			var ac = acorn_scene.instantiate()
			ac.position = pos
			world_layer.add_child(ac)
		elif roll < 0.55:
			var br = branch_scene.instantiate()
			br.position = pos
			world_layer.add_child(br)
		elif roll < 0.80:
			var lf = leaves_scene.instantiate()
			lf.position = pos
			world_layer.add_child(lf)
		else:
			var ms = mushroom_scene.instantiate()
			ms.position = pos
			world_layer.add_child(ms)


func add_resource(res_name: String, amount: int = 1) -> void:
	if inventory.has(res_name):
		inventory[res_name] += amount
		emit_signal("inventory_changed")
		emit_signal(
			"status_message",
			"+%d %s collected!" % [amount, res_name.capitalize()]
		)


func add_health(amount: float) -> void:
	var old = forest_health
	forest_health = clamp(forest_health + amount, 0.0, 100.0)
	
	if abs(forest_health - old) > 0.01:
		emit_signal("health_changed", forest_health, old)


func discover(species_name: String) -> void:
	if not species_name in discovered_species:
		discovered_species.append(species_name)
		emit_signal("species_discovered", species_name)
		emit_signal("status_message", "New friends are coming: " + species_name + "!")
		add_health(4.0)


func _evaluate_ecosystem(_delta: float) -> void:
	var tree_root = get_tree()
	
	if not tree_root:
		return
	
	var acorns = tree_root.get_nodes_in_group("acorns")
	var squirrels = tree_root.get_nodes_in_group("squirrels")
	var plants = tree_root.get_nodes_in_group("plants")
	var rabbits = tree_root.get_nodes_in_group("rabbits")
	var foxes = tree_root.get_nodes_in_group("foxes")
	var deers = tree_root.get_nodes_in_group("deer")
	var waters = tree_root.get_nodes_in_group("water")
	
	# Spawn squirrels when there are unclaimed acorns
	# and the squirrel population is still low.
	if acorns.size() > 0 \
	and squirrels.size() < min(3, acorns.size() + 1) \
	and squirrel_spawn_cooldown <= 0.0:
		_spawn_animal("squirrel")
		squirrel_spawn_cooldown = 7.0
	
	# Count mature plants.
	var mature_plants = 0
	
	for p in plants:
		if p.stage >= 1:
			mature_plants += 1
	
	# Spawn rabbits when there are enough mature plants (minimum 2) and water nearby.
	if mature_plants >= 2 \
	and waters.size() >= 1 \
	and rabbits.size() < min(3, int(float(mature_plants) / 2.0) + 1) \
	and rabbit_spawn_cooldown <= 0.0:
		_spawn_animal("rabbit")
		rabbit_spawn_cooldown = 10.0
		
	# Spawn foxes when there are at least 2 rabbits
	# and forest health is at least 40%.
	if rabbits.size() >= 2 \
	and forest_health >= 40.0 \
	and foxes.size() < 2 \
	and fox_spawn_cooldown <= 0.0:
		_spawn_animal("fox")
		fox_spawn_cooldown = 16.0
		
	# Spawn deer when forest health is at least 70%
	# and there are at least two water sources.
	if forest_health >= 70.0 \
	and waters.size() >= 2 \
	and deers.size() < 2 \
	and deer_spawn_cooldown <= 0.0:
		_spawn_animal("deer")
		deer_spawn_cooldown = 22.0
		
	if total_nest >= 3 \
	and bird_spawn_cooldown <= 0.0:
		_spawn_animal("bird")
		bird_spawn_cooldown = 10.0



func _spawn_animal(species: String) -> void:
	var main_scene = get_tree().current_scene
	
	if not main_scene:
		return
	
	var ysort_layer = main_scene.get_node_or_null("WorldObjects")
	
	if not ysort_layer:
		ysort_layer = main_scene
	
	var spawn_edges = [
		Vector2(randf_range(100, 1180), 40),
		Vector2(randf_range(100, 1180), 680),
		Vector2(40, randf_range(100, 620)),
		Vector2(1240, randf_range(100, 620))
	]
	
	var spawn_pos = spawn_edges.pick_random()
	
	if species == "squirrel":
		var s = squirrel_scene.instantiate()
		s.position = spawn_pos
		ysort_layer.add_child(s)
		discover("Squirrel")
	
	elif species == "rabbit":
		var r = rabbit_scene.instantiate()
		r.position = spawn_pos
		ysort_layer.add_child(r)
		discover("Rabbit")
	
	elif species == "fox":
		var f = fox_scene.instantiate()
		f.position = spawn_pos
		ysort_layer.add_child(f)
		discover("Fox")
	
	elif species == "deer":
		var d = deer_scene.instantiate()
		d.position = spawn_pos
		ysort_layer.add_child(d)
		discover("Deer")
		
	elif species == "bird":
		var b = bird_scene.instantiate()
		b.position = spawn_pos
		ysort_layer.add_child(b)
		discover("Bird")
