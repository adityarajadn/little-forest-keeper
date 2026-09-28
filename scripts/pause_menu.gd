extends Control
class_name PauseMenu

signal resumed()
signal settings_opened()
signal returned_to_menu()

@onready var btn_resume: Button = $PanelContainer/VBox/BtnResume
@onready var btn_settings: Button = $PanelContainer/VBox/BtnSettings
@onready var btn_menu: Button = $PanelContainer/VBox/BtnMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if btn_resume:
		btn_resume.pressed.connect(resume_game)
	if btn_settings:
		btn_settings.pressed.connect(_on_settings_pressed)
	if btn_menu:
		btn_menu.pressed.connect(_on_menu_pressed)

func pause_game() -> void:
	visible = true
	get_tree().paused = true

func resume_game() -> void:
	visible = false
	get_tree().paused = false
	emit_signal("resumed")

func _on_settings_pressed() -> void:
	emit_signal("settings_opened")

func _on_menu_pressed() -> void:
	get_tree().paused = false
	emit_signal("returned_to_menu")
	SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
