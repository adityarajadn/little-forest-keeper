extends Node2D
class_name ForestGround

var grass_patches: Array[Vector2] = []
var leaf_patches: Array[Vector2] = []
var stone_patches: Array[Vector2] = []

func _ready() -> void:
	# Generate decorative background patches deterministically
	var rng = RandomNumberGenerator.new()
	rng.seed = 2026
	
	for i in range(45):
		grass_patches.append(Vector2(rng.randf_range(50, 1230), rng.randf_range(50, 670)))
	for i in range(30):
		leaf_patches.append(Vector2(rng.randf_range(50, 1230), rng.randf_range(50, 670)))
	for i in range(12):
		stone_patches.append(Vector2(rng.randf_range(80, 1200), rng.randf_range(80, 640)))

func _draw() -> void:
	var gm = get_node_or_null("/root/Main/GameManager")
	var health_ratio = 0.1
	if gm:
		health_ratio = clamp(gm.forest_health / 100.0, 0.0, 1.0)
	
	# Warna tanah dasar: dari tanah kecoklatan redup -> tanah subur hangat keemasan
	var dead_ground = Color("#3e3226")
	var lush_ground = Color("#4b4231")
	var ground_color = dead_ground.lerp(lush_ground, health_ratio)
	
	draw_rect(Rect2(0, 0, 1280, 720), ground_color)
	
	# Garis batas hutan (border vignette)
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.1, 0.08, 0.05, 0.4), false, 12.0)
	
	# Bercak rumput
	var dead_grass = Color("#585437", 0.4)
	var lush_grass = Color("#6a8537", 0.7)
	var grass_col = dead_grass.lerp(lush_grass, health_ratio)
	for p in grass_patches:
		draw_circle(p, 16.0, grass_col)
		draw_circle(p + Vector2(6, 4), 10.0, grass_col)
		# Helai rumput
		draw_line(p, p + Vector2(-3, -7), grass_col * 1.2, 2.0)
		draw_line(p, p + Vector2(2, -8), grass_col * 1.2, 2.0)
	
	# Daun-daun gugur di tanah (Autumn leaves)
	for p in leaf_patches:
		draw_ellipse(p, 4, 2, Color("#d97706", 0.75))
		draw_line(p, p + Vector2(3, -1), Color("#b45309", 0.8), 1.0)
		
	# Bebatuan hutan kecil
	for p in stone_patches:
		draw_ellipse(p + Vector2(0, 2), 7, 3, Color(0.1, 0.1, 0.1, 0.3))
		draw_ellipse(p, 6, 4, Color("#78716c"))
		draw_ellipse(p + Vector2(-1, -1), 4, 2.5, Color("#a8a29e"))
