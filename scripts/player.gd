extends CharacterBody2D
class_name ForestKeeperPlayer

@export var speed: float = 180.0
@export var placement_range: float = 280.0
@export var show_cursor: bool = true

@onready var sprite: Sprite2D = $Sprite2D

var anim_timer: float = 0.0
var footstep_timer: float = 0.0
var footstep_interval: float = 0.3

var facing_dir: int = 1
var is_moving: bool = false
var preview_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("player")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():

		var gm = get_node_or_null("/root/Main/GameManager")

		if gm:
			match event.keycode:
				KEY_1:
					gm.select_resource("acorn")

				KEY_2:
					gm.select_resource("water")

				KEY_3:
					gm.select_resource("mushroom")

				KEY_4:
					gm.select_resource("leaves")

				KEY_5:
					gm.select_resource("branch")

				KEY_E:
					_try_pickup_resource()

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_try_place_resource()


func _physics_process(delta: float) -> void:

	# ==========================================
	# MOVEMENT - MENGGUNAKAN INPUT MAP
	# ==========================================

	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if input_vector != Vector2.ZERO:

		velocity = velocity.move_toward(
			input_vector * speed,
			speed * 10.0 * delta
		)

		anim_timer += delta * 8.0
		is_moving = true

		# ==========================================
		# FOOTSTEP SOUND
		# ==========================================

		footstep_timer -= delta

		if footstep_timer <= 0.0:
			AudioManager.play_sfx(
				preload("res://assets/audio/SFX Grass Step.wav")
			)

			footstep_timer = footstep_interval

		# ==========================================
		# MENENTUKAN ARAH KARAKTER
		# ==========================================

		if input_vector.x > 0.05:
			facing_dir = 1

		elif input_vector.x < -0.05:
			facing_dir = -1

	else:

		velocity = velocity.move_toward(
			Vector2.ZERO,
			speed * 12.0 * delta
		)

		anim_timer += delta * 3.5
		is_moving = false

		# Reset supaya ketika mulai jalan lagi
		# suara langsung dimainkan
		footstep_timer = 0.0


	move_and_slide()


	# ==========================================
	# BATAS AREA PLAYER
	# ==========================================

	position.x = clamp(
		position.x,
		30.0,
		1250.0
	)

	position.y = clamp(
		position.y,
		30.0,
		690.0
	)


	# ==========================================
	# UPDATE TARGET CURSOR
	# ==========================================

	var mouse_world := get_global_mouse_position()
	var diff := mouse_world - global_position

	if diff.length() > placement_range:
		preview_pos = (
			global_position
			+ diff.normalized() * placement_range
		)
	else:
		preview_pos = mouse_world


	# ==========================================
	# ANIMATION
	# ==========================================

	if sprite:

		if is_moving:
			sprite.frame = 4 + (int(anim_timer) % 4)

		else:
			sprite.frame = int(anim_timer) % 4


	queue_redraw()


# ==========================================
# CEK MODAL
# ==========================================

func _is_modal_active() -> bool:

	var hud = get_node_or_null("/root/Main/HUD")

	if not hud:
		return false

	for modal_name in [
		"ForestJournal",
		"PauseMenu",
		"Settings",
		"WinterChecklist",
		"WinScreen"
	]:

		var node = hud.get_node_or_null(modal_name)

		if node and node.visible:
			return true

	return false


# ==========================================
# PLACE RESOURCE
# ==========================================

func _try_place_resource() -> void:

	if _is_modal_active():
		return

	var gm = get_node_or_null(
		"/root/Main/GameManager"
	)

	if not gm:
		return

	var main_scene = get_tree().current_scene

	var parent_layer = main_scene.get_node_or_null(
		"WorldObjects"
	)

	if not parent_layer:
		parent_layer = main_scene

	gm.use_selected_resource(
		preview_pos,
		parent_layer
	)


# ==========================================
# PICKUP RESOURCE
# ==========================================

func _try_pickup_resource() -> void:

	if _is_modal_active():
		return

	var gm = get_node_or_null(
		"/root/Main/GameManager"
	)

	if not gm:
		return

	var pickup_distance: float = 64.0


	# ==========================================
	# 1. CEK SUMBER AIR
	# ==========================================

	var waters = get_tree().get_nodes_in_group(
		"water"
	)

	var closest_water: Node2D = null
	var min_water_dist: float = 68.0

	for w in waters:

		if is_instance_valid(w) and (w is Node2D):

			var d = global_position.distance_to(
				w.global_position
			)

			if d < min_water_dist:

				min_water_dist = d
				closest_water = w


	if closest_water:

		if gm.inventory.get("water", 0) >= 8:

			gm.status_message.emit(
				"Water inventory is full (Max 8)!"
			)

			return

		gm.add_resource(
			"water",
			1
		)

		gm.status_message.emit(
			"Collected fresh water from spring (+1)"
		)

		return


	# ==========================================
	# 2. CEK ITEM DI TANAH
	# ==========================================

	var candidate_groups = [
		"acorns",
		"branches",
		"leaves_ground",
		"mushrooms"
	]

	var best_node: Node2D = null
	var best_dist: float = pickup_distance
	var best_type: String = ""


	for group in candidate_groups:

		var nodes = get_tree().get_nodes_in_group(
			group
		)

		for node in nodes:

			if not is_instance_valid(node):
				continue

			if not (node is Node2D):
				continue

			if group == "acorns":

				if node.get("is_claimed") == true:
					continue


			var d = global_position.distance_to(
				node.global_position
			)


			if d < best_dist:

				best_dist = d
				best_node = node


				if group == "acorns":
					best_type = "acorn"

				elif group == "branches":
					best_type = "branch"

				elif group == "leaves_ground":
					best_type = "leaves"

				elif group == "mushrooms":
					best_type = "mushroom"


	if best_node and best_type != "":

		gm.add_resource(
			best_type,
			1
		)


		var display_names = {
			"acorn": "Acorn",
			"branch": "Branch",
			"leaves": "Fallen Leaves",
			"mushroom": "Forest Mushroom"
		}


		gm.status_message.emit(
			"Picked %s (+1)" %
			display_names.get(
				best_type,
				best_type
			)
		)


		best_node.queue_free()


# ==========================================
# DRAW CURSOR
# ==========================================

func _draw() -> void:

	if _is_modal_active():
		return

	if not show_cursor:
		return


	var local_preview := to_local(
		preview_pos
	)

	draw_arc(
		local_preview,
		14.0,
		0,
		TAU,
		24,
		Color(1, 0.9, 0.5, 0.6),
		2.0
	)

	draw_circle(
		local_preview,
		3.0,
		Color(1, 0.9, 0.5, 0.8)
	)
