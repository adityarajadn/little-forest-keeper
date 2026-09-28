extends Control
class_name WinScreen

@onready var stat_label: Label = $PanelContainer/VBoxContainer/AnimalCensus
@onready var health_val_label: Label = $PanelContainer/VBoxContainer/HealthValue
@onready var btn_play_again: Button = $PanelContainer/VBoxContainer/BtnPlayAgain
@onready var btn_main_menu: Button = $PanelContainer/VBoxContainer/BtnMainMenu

func _ready() -> void:
	if btn_play_again:
		btn_play_again.pressed.connect(_on_play_again)
	if btn_main_menu:
		btn_main_menu.pressed.connect(_on_main_menu)

func setup_summary(squirrel_count: int, rabbit_count: int, fox_count: int, deer_count: int, health: float, day: int) -> void:
	if stat_label:
		stat_label.text = "Squirrel: %d\nRabbit: %d\nFox: %d\nDeer: %d\nDay Passed: %d Days" % [
			squirrel_count, rabbit_count, fox_count, deer_count, day
		]
	if health_val_label:
		health_val_label.text = "Forest Health: %d%%" % int(health)

func _on_play_again() -> void:
	get_tree().paused = false
	SceneTransition.reload_scene()

func _on_main_menu() -> void:
	get_tree().paused = false
	SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
