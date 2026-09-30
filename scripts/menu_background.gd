extends Control
class_name MenuBackground

var leaves: Array[Dictionary] = []
var spores: Array[Dictionary] = []
var anim_time: float = 0.0

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = 42
	
	# Daun gugur musim gugur
	for i in range(25):
		leaves.append({
			"pos": Vector2(rng.randf_range(0, 1280), rng.randf_range(-50, 720)),
			"speed": rng.randf_range(25, 60),
			"sway_speed": rng.randf_range(1.5, 3.0),
			"sway_dist": rng.randf_range(20, 50),
			"size": rng.randf_range(4, 8),
			"color": [Color("#d97706"), Color("#ea580c"), Color("#b45309"), Color("#f59e0b")].pick_random(),
			"angle": rng.randf_range(0, TAU)
		})
		
	# Spora / kilau cahaya hutan ajaib
	for i in range(20):
		spores.append({
			"pos": Vector2(rng.randf_range(50, 1230), rng.randf_range(100, 680)),
			"speed_y": rng.randf_range(-15, -5),
			"pulse_speed": rng.randf_range(1.0, 3.0),
			"radius": rng.randf_range(1.5, 3.0)
		})

func _process(delta: float) -> void:
	anim_time += delta
	
	# Update leaves falling
	for leaf in leaves:
		leaf["pos"].y += leaf["speed"] * delta
		leaf["pos"].x += sin(anim_time * leaf["sway_speed"]) * 0.8
		leaf["angle"] += delta * 1.5
		if leaf["pos"].y > 740:
			leaf["pos"].y = -20
			leaf["pos"].x = randf_range(0, 1280)
			
	# Update spores floating
	for sp in spores:
		sp["pos"].y += sp["speed_y"] * delta
		if sp["pos"].y < 50:
			sp["pos"].y = 700
			sp["pos"].x = randf_range(50, 1230)
			
	queue_redraw()

func _draw() -> void:
	# Gradien langit senja musim gugur (Autumn Twilight)
	var top_color = Color("#23150c")
	var mid_color = Color("#4a230e")
	var bottom_color = Color("#6b3714")
	
	draw_rect(Rect2(0, 0, 1280, 240), top_color)
	draw_rect(Rect2(0, 240, 1280, 240), mid_color)
	draw_rect(Rect2(0, 480, 1280, 240), bottom_color)
	
	# Bukit siluet latar belakang
	draw_circle(Vector2(200, 800), 450, Color("#1f1008", 0.7))
	draw_circle(Vector2(1100, 820), 480, Color("#1f1008", 0.7))
	draw_circle(Vector2(640, 880), 520, Color("#150b05", 0.9))
	
	# Pohon siluet di kejauhan
	_draw_tree_silhouette(Vector2(140, 480), 1.2)
	_draw_tree_silhouette(Vector2(240, 520), 0.9)
	_draw_tree_silhouette(Vector2(1060, 500), 1.1)
	_draw_tree_silhouette(Vector2(1180, 470), 1.3)
	
	# Spora kilau emas
	for sp in spores:
		var alpha = (sin(anim_time * sp["pulse_speed"]) + 1.0) * 0.35 + 0.2
		draw_circle(sp["pos"], sp["radius"], Color(1.0, 0.85, 0.4, alpha))
		draw_circle(sp["pos"], sp["radius"] * 2.0, Color(1.0, 0.85, 0.4, alpha * 0.2))
		
	# Daun-daun berguguran
	for leaf in leaves:
		var lp = leaf["pos"]
		draw_set_transform(lp, leaf["angle"], Vector2.ONE)
		draw_ellipse(Vector2.ZERO, leaf["size"], leaf["size"] * 0.55, leaf["color"])
		draw_line(Vector2(-leaf["size"], 0), Vector2(leaf["size"], 0), leaf["color"] * 0.8, 1.0)
		draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func _draw_tree_silhouette(base_pos: Vector2, scale_factor: float) -> void:
	var col = Color("#120803", 0.85)
	# Batang
	draw_rect(Rect2(base_pos.x - (4 * scale_factor), base_pos.y - (40 * scale_factor), 8 * scale_factor, 50 * scale_factor), col)
	# Kanopi bersusun
	draw_circle(base_pos + Vector2(0, -50 * scale_factor), 32 * scale_factor, col)
	draw_circle(base_pos + Vector2(-16 * scale_factor, -40 * scale_factor), 24 * scale_factor, col)
	draw_circle(base_pos + Vector2(16 * scale_factor, -40 * scale_factor), 24 * scale_factor, col)
	draw_circle(base_pos + Vector2(0, -75 * scale_factor), 26 * scale_factor, col)
