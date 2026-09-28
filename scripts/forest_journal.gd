extends Control
class_name ForestJournal

signal closed()

@onready var animal_sprite: TextureRect = $BookContainer/BookPages/LeftPage/VBox/IllustrationFrame/AnimalTexture
@onready var animal_name_label: Label = $BookContainer/BookPages/LeftPage/VBox/AnimalNameLabel
@onready var status_badge: Label = $BookContainer/BookPages/LeftPage/VBox/StatusBadge
@onready var tier_label: Label = $BookContainer/BookPages/LeftPage/VBox/TierLabel

@onready var req_content: Label = $BookContainer/BookPages/RightPage/VBox/ReqContent
@onready var role_content: Label = $BookContainer/BookPages/RightPage/VBox/RoleContent
@onready var lore_content: Label = $BookContainer/BookPages/RightPage/VBox/LoreContent
@onready var bar_rarity: ProgressBar = $BookContainer/BookPages/RightPage/VBox/StatContainer/BarRarity
@onready var bar_contribution: ProgressBar = $BookContainer/BookPages/RightPage/VBox/StatContainer/BarContribution

@onready var btn_tab_squirrel: Button = $BookContainer/TabsContainer/TabSquirrel
@onready var btn_tab_rabbit: Button = $BookContainer/TabsContainer/TabRabbit
@onready var btn_tab_fox: Button = $BookContainer/TabsContainer/TabFox
@onready var btn_tab_deer: Button = $BookContainer/TabsContainer/TabDeer

@onready var btn_prev: Button = $BookContainer/NavContainer/BtnPrev
@onready var btn_next: Button = $BookContainer/NavContainer/BtnNext
@onready var btn_close: Button = $BookContainer/BtnClose

var current_index: int = 0

const ANIMALS_DATA = [
	{
		"id": "Squirrel",
		"name": "Forest Squirrel",
		"tier": "Stage 1 — Awakening",
		"texture_path": "res://assets/sprites/squirrel.png",
		"hframes": 8,
		"req": "Place an Acorn on open ground.",
		"role": "Collects acorns and plants them back into the ground, allowing new tree sprouts to grow naturally.",
		"lore": "\"This nimble creature is the forest's greatest tree planter. Where there are acorns, new life will follow.\"",
		"rarity": 25,
		"contribution": 85,
		"hint": "A small tree-climbing creature that loves collecting and planting acorns."
	},
	{
		"id": "Rabbit",
		"name": "Meadow Rabbit",
		"tier": "Stage 2 — Growth",
		"texture_path": "res://assets/sprites/rabbit.png",
		"hframes": 6,
		"req": "At least 2 plants or bushes are fully grown, with moist soil nearby.",
		"role": "Improves the health of the forest and helps attract predators that maintain the ecosystem's balance.",
		"lore": "\"A rabbit hopping between the bushes is the first sign that the forest has awakened from its slumber.\"",
		"rarity": 45,
		"contribution": 60,
		"hint": "Grow lush bushes and provide enough water to attract rabbits."
	},
	{
		"id": "Fox",
		"name": "Red Fox",
		"tier": "Stage 3 — Balance",
		"texture_path": "res://assets/sprites/fox.png",
		"hframes": 6,
		"req": "Rabbits are present and Forest Health reaches ≥ 35%.",
		"role": "Maintains the balance of the ecosystem by helping regulate wildlife populations.",
		"lore": "\"Its footsteps are as silent as falling leaves. The fox keeps the forest balanced and in harmony.\"",
		"rarity": 70,
		"contribution": 75,
		"hint": "A balanced ecosystem with a healthy rabbit population will attract a fox."
	},
	{
		"id": "Deer",
		"name": "Golden Forest Deer",
		"tier": "Stage 4 — Harmony",
		"texture_path": "res://assets/sprites/deer.png",
		"hframes": 6,
		"req": "A fresh water source is flowing and Forest Health reaches ≥ 65%.",
		"role": "A rare species that represents the highest level of harmony before winter arrives.",
		"lore": "\"Its magnificent branching antlers resemble the branches of autumn trees. Its presence symbolizes the forest's blessing.\"",
		"rarity": 95,
		"contribution": 100,
		"hint": "Create a thriving and peaceful forest with a fresh water source to welcome this majestic deer."
	}
]

func _ready() -> void:
	btn_tab_squirrel.pressed.connect(func(): show_animal(0))
	btn_tab_rabbit.pressed.connect(func(): show_animal(1))
	btn_tab_fox.pressed.connect(func(): show_animal(2))
	btn_tab_deer.pressed.connect(func(): show_animal(3))
	
	btn_prev.pressed.connect(_on_prev_pressed)
	btn_next.pressed.connect(_on_next_pressed)
	btn_close.pressed.connect(close_journal)
	
	show_animal(0)


func open_journal() -> void:
	visible = true
	show_animal(current_index)


func close_journal() -> void:
	visible = false
	emit_signal("closed")


func show_animal(index: int) -> void:
	current_index = clamp(index, 0, ANIMALS_DATA.size() - 1)
	var data = ANIMALS_DATA[current_index]
	
	var gm = get_node_or_null("/root/Main/GameManager")
	var is_discovered = false
	
	if gm and data["id"] in gm.discovered_species:
		is_discovered = true
	
	# Update tab highlights
	btn_tab_squirrel.button_pressed = (current_index == 0)
	btn_tab_rabbit.button_pressed = (current_index == 1)
	btn_tab_fox.button_pressed = (current_index == 2)
	btn_tab_deer.button_pressed = (current_index == 3)
	
	# Update navigation button states
	btn_prev.disabled = (current_index == 0)
	btn_next.disabled = (current_index == ANIMALS_DATA.size() - 1)
	
	# Load texture and display the first spritesheet frame
	var full_tex = load(data["texture_path"])
	
	if full_tex and animal_sprite:
		var atlas = AtlasTexture.new()
		atlas.atlas = full_tex
		
		var frame_w = full_tex.get_width() / data["hframes"]
		atlas.region = Rect2(
			0,
			0,
			frame_w,
			full_tex.get_height()
		)
		
		animal_sprite.texture = atlas
	
	if is_discovered:
		# Display discovered animal information
		animal_name_label.text = data["name"]
		tier_label.text = data["tier"]
		
		status_badge.text = "RECORDED IN JOURNAL"
		status_badge.modulate = Color("#38b000")
		
		if animal_sprite:
			animal_sprite.modulate = Color.WHITE
		
		req_content.text = data["req"]
		role_content.text = data["role"]
		lore_content.text = data["lore"]
		
		bar_rarity.value = data["rarity"]
		bar_contribution.value = data["contribution"]
		
	else:
		# Display locked animal information
		animal_name_label.text = "??? (Undiscovered)"
		tier_label.text = data["tier"].substr(0, 4) + "  (Locked)"
		
		status_badge.text = "UNDISCOVERED"
		status_badge.modulate = Color("#ffb703")
		
		if animal_sprite:
			animal_sprite.modulate = Color(0.12, 0.12, 0.15, 0.9)
		
		req_content.text = "Hint: " + data["hint"]
		
		role_content.text = "Ecosystem data has not yet been recorded. Bring life back to the forest to discover this creature."
		
		lore_content.text = "\"This page remains empty, waiting for your story to be written, Forest Keeper.\""
		
		bar_rarity.value = 0
		bar_contribution.value = 0


func _on_prev_pressed() -> void:
	if current_index > 0:
		show_animal(current_index - 1)


func _on_next_pressed() -> void:
	if current_index < ANIMALS_DATA.size() - 1:
		show_animal(current_index + 1)
