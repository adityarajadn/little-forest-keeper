extends CanvasLayer
class_name HUD

@onready var health_bar: ProgressBar = $TopBar/HealthBar
@onready var health_label: Label = $TopBar/HealthLabel
@onready var status_banner: Label = $StatusBanner
@onready var day_label: Label = $TopRight/DayPanel/MarginContainer/DayLabel

@onready var btn_checklist: Button = $TopRight/BtnChecklist
@onready var btn_journal: Button = $TopRight/BtnJournal
@onready var btn_pause: Button = $TopRight/BtnPause
@onready var forest_journal: Control = $ForestJournal
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var settings_menu: SettingsMenu = $Settings
@onready var winter_checklist: ChecklistModal = $WinterChecklist
@onready var win_screen: WinScreen = $WinScreen

@onready var btn_acorn: Button = $Hotbar/BtnAcorn
@onready var btn_water: Button = $Hotbar/BtnWater
@onready var btn_mushroom: Button = $Hotbar/BtnMushroom
@onready var btn_leaves: Button = $Hotbar/BtnLeaves
@onready var btn_branch: Button = $Hotbar/BtnBranch
@onready var falling_particles: GPUParticles2D = $FallingLeaves

var snowflake_tex: Texture2D = preload("res://assets/sprites/snowflakes.png")

@onready var btn_acorn_label: Label = $Hotbar/BtnAcorn/BtnLabel
@onready var btn_water_label: Label = $Hotbar/BtnWater/BtnLabel
@onready var btn_mushroom_label: Label = $Hotbar/BtnMushroom/BtnLabel
@onready var btn_leaves_label: Label = $Hotbar/BtnLeaves/BtnLabel
@onready var btn_branch_label: Label = $Hotbar/BtnBranch/BtnLabel

var banner_timer: float = 0.0

func _ready() -> void:
	var gm = get_node_or_null("/root/Main/GameManager")
	if gm:
		gm.health_changed.connect(_on_health_changed)
		gm.inventory_changed.connect(_on_inventory_changed)
		gm.status_message.connect(_show_banner)
		gm.species_discovered.connect(_on_species_discovered)
		if gm.has_signal("day_changed"):
			gm.day_changed.connect(_on_day_changed)
			_on_day_changed(gm.current_day)
		_update_ui(gm.forest_health)
		_update_hotbar(gm)
		
	btn_acorn.pressed.connect(func(): _select("acorn"))
	btn_water.pressed.connect(func(): _select("water"))
	btn_mushroom.pressed.connect(func(): _select("mushroom"))
	btn_leaves.pressed.connect(func(): _select("leaves"))
	if btn_branch:
		btn_branch.pressed.connect(func(): _select("branch"))
	
	if btn_journal:
		btn_journal.pressed.connect(_toggle_journal)
	if btn_checklist:
		btn_checklist.pressed.connect(_toggle_checklist)
	if btn_pause:
		btn_pause.pressed.connect(_toggle_pause)
		
	if pause_menu:
		pause_menu.settings_opened.connect(_open_settings)
	if settings_menu:
		settings_menu.closed.connect(_on_settings_closed)
	if winter_checklist:
		winter_checklist.winter_accepted.connect(_on_winter_accepted)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			_handle_escape()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_P:
			_toggle_pause()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_J or event.keycode == KEY_B:
			if not (pause_menu and pause_menu.visible) and not (settings_menu and settings_menu.visible):
				_toggle_journal()
				get_viewport().set_input_as_handled()

func _handle_escape() -> void:
	if win_screen and win_screen.visible:
		return
	if winter_checklist and winter_checklist.visible:
		winter_checklist.close_checklist()
		return
	if settings_menu and settings_menu.visible:
		settings_menu.close_menu()
		return
	if forest_journal and forest_journal.visible:
		forest_journal.close_journal()
		return
	_toggle_pause()

func _toggle_pause() -> void:
	if not pause_menu:
		return
	if settings_menu and settings_menu.visible:
		settings_menu.close_menu()
		return
	if pause_menu.visible:
		pause_menu.resume_game()
	else:
		if forest_journal and forest_journal.visible:
			forest_journal.close_journal()
		pause_menu.pause_game()

func _open_settings() -> void:
	if pause_menu:
		pause_menu.visible = false
	if settings_menu:
		settings_menu.open_menu()

func _on_settings_closed() -> void:
	if get_tree().paused and pause_menu:
		pause_menu.visible = true

func _toggle_journal() -> void:
	if not forest_journal or get_tree().paused:
		return
	if forest_journal.visible:
		forest_journal.close_journal()
	else:
		forest_journal.open_journal()

func _process(delta: float) -> void:
	if banner_timer > 0.0:
		banner_timer -= delta
		if banner_timer <= 0.0:
			status_banner.modulate.a = 0.0
		else:
			status_banner.modulate.a = min(1.0, banner_timer)

func _select(res_name: String) -> void:
	var gm = get_node_or_null("/root/Main/GameManager")
	if gm:
		gm.select_resource(res_name)

func _on_health_changed(new_val: float, _old_val: float) -> void:
	_update_ui(new_val)

func _update_ui(health: float) -> void:
	if health_bar:
		health_bar.value = health
	
	var gm = get_node_or_null("/root/Main/GameManager")
	var is_late_autumn = gm and gm.current_day >= 3
	
	var status_text = ""
	if health < 25.0:
		status_text = "Barren Forest"
	elif health < 50.0:
		status_text = "Recovering"
	elif health < 75.0:
		status_text = "Healthy Forest"
	elif health < 85.0:
		status_text = "Thriving Forest"
	else:
		if not is_late_autumn:
			status_text = "Waiting for Late Autumn (Day 3+)"
		else:
			status_text = "Winter Approaching"
		
	if health_label:
		health_label.text = "Forest Health: %d%% — %s" % [int(health), status_text]

	if btn_checklist:
		if health >= 85.0 and is_late_autumn:
			if not btn_checklist.visible:
				btn_checklist.visible = true
				_show_banner("Winter is approaching! Check your preparations in the checklist.")
		else:
			btn_checklist.visible = false

func _on_inventory_changed() -> void:
	var gm = get_node_or_null("/root/Main/GameManager")
	if gm:
		_update_hotbar(gm)

func _update_hotbar(gm: Node) -> void:
	btn_acorn_label.text = "[1] Acorn (%d)" % gm.inventory.get("acorn", 0)
	btn_water_label.text = "[2] Water (%d)" % gm.inventory.get("water", 0)
	btn_mushroom_label.text = "[3] Mushroom (%d)" % gm.inventory.get("mushroom", 0)
	btn_leaves_label.text = "[4] Leaves (%d)" % gm.inventory.get("leaves", 0)
	if btn_branch_label:
		btn_branch_label.text = "[5] Branch (%d)" % gm.inventory.get("branch", 0)
	
	btn_acorn.button_pressed = (gm.selected_resource == "acorn")
	btn_water.button_pressed = (gm.selected_resource == "water")
	btn_mushroom.button_pressed = (gm.selected_resource == "mushroom")
	btn_leaves.button_pressed = (gm.selected_resource == "leaves")
	if btn_branch:
		btn_branch.button_pressed = (gm.selected_resource == "branch")

func _on_species_discovered(_species: String) -> void:
	if btn_journal:
		# Animasi kecil pop pada button buku
		var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		btn_journal.scale = Vector2(1.2, 1.2)
		tween.tween_property(btn_journal, "scale", Vector2.ONE, 0.4)
		
	if forest_journal and forest_journal.visible:
		forest_journal.show_animal(forest_journal.current_index)

func _show_banner(msg: String) -> void:
	if status_banner:
		status_banner.text = msg
		status_banner.modulate.a = 1.0
		banner_timer = 2.5

func _on_day_changed(day: int) -> void:
	if day_label:
		day_label.text = "Autumn Day %d" % day
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		day_label.scale = Vector2(1.2, 1.2)
		tween.tween_property(day_label, "scale", Vector2.ONE, 0.5)
	var gm = get_node_or_null("/root/Main/GameManager")
	if gm:
		_update_ui(gm.forest_health)

func _toggle_checklist() -> void:
	if not winter_checklist or (get_tree().paused and not winter_checklist.visible):
		return
	if winter_checklist.visible:
		winter_checklist.close_checklist()
	else:
		if forest_journal and forest_journal.visible:
			forest_journal.close_journal()
		_refresh_checklist()
		winter_checklist.open_checklist()

func _refresh_checklist() -> void:
	var tree_root = get_tree()
	var gm = get_node_or_null("/root/Main/GameManager")
	if not tree_root or not gm:
		return
	var acorns_ground = tree_root.get_nodes_in_group("acorns").size()
	var acorns_inv = gm.inventory.get("acorn", 0) if gm else 0
	var total_food = acorns_ground + acorns_inv
	var waters = tree_root.get_nodes_in_group("water").size()
	var plants = tree_root.get_nodes_in_group("plants").size()
	var nests = tree_root.get_nodes_in_group("nests").size()
	var animals = tree_root.get_nodes_in_group("squirrels").size() + \
				  tree_root.get_nodes_in_group("rabbits").size() + \
				  tree_root.get_nodes_in_group("foxes").size() + \
				  tree_root.get_nodes_in_group("deer").size()
	
	winter_checklist.update_status(total_food, waters, plants, nests, animals)

func switch_to_snow_particles() -> void:
	if falling_particles and snowflake_tex:
		falling_particles.texture = snowflake_tex
		falling_particles.amount = 45
		falling_particles.lifetime = 9.0
		if falling_particles.process_material is ParticleProcessMaterial:
			var mat: ParticleProcessMaterial = falling_particles.process_material.duplicate()
			mat.color = Color(1.0, 1.0, 1.0, 0.95)
			mat.gravity = Vector3(10.0, 32.0, 0.0)
			mat.initial_velocity_min = 20.0
			mat.initial_velocity_max = 50.0
			mat.angular_velocity_min = -25.0
			mat.angular_velocity_max = 25.0
			mat.spread = 25.0
			falling_particles.process_material = mat
		falling_particles.restart()

func _on_winter_accepted() -> void:
	# Switch weather particles from autumn leaves to winter snowflakes!
	switch_to_snow_particles()
	if day_label:
		day_label.text = "Winter Has Arrived"
		
	# Trigger ending celebration & win screen
	var tree_root = get_tree()
	var gm = get_node_or_null("/root/Main/GameManager")
	var squirrels = tree_root.get_nodes_in_group("squirrels").size()
	var rabbits = tree_root.get_nodes_in_group("rabbits").size()
	var foxes = tree_root.get_nodes_in_group("foxes").size()
	var deers = tree_root.get_nodes_in_group("deer").size()
	
	if win_screen:
		win_screen.setup_summary(squirrels, rabbits, foxes, deers, gm.forest_health if gm else 100.0, gm.current_day if gm else 1)
		win_screen.visible = true
		get_tree().paused = true
