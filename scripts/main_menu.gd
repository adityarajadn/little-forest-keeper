extends Control
class_name MainMenu

@onready var btn_play: Button = $MenuLayout/VBoxCenter/ButtonsContainer/BtnPlay
@onready var btn_how_to_play: Button = $MenuLayout/VBoxCenter/ButtonsContainer/BtnHowToPlay
@onready var btn_settings: Button = $MenuLayout/VBoxCenter/ButtonsContainer/HBoxContainer/BtnSettings
@onready var btn_credits: Button = $MenuLayout/VBoxCenter/ButtonsContainer/HBoxContainer/BtnCredits
@onready var btn_quit: Button = $MenuLayout/VBoxCenter/ButtonsContainer/BtnQuit

@onready var how_to_play_panel: Control = $HowToPlay
@onready var settings_panel: Control = $Settings
@onready var credits_panel: Control = $Credits

func _ready() -> void:
	if btn_play:
		btn_play.pressed.connect(_on_play_pressed)
	if btn_how_to_play:
		btn_how_to_play.pressed.connect(_on_how_to_play_pressed)
	if btn_settings:
		btn_settings.pressed.connect(_on_settings_pressed)
	if btn_credits:
		btn_credits.pressed.connect(_on_credits_pressed)
	if btn_quit:
		btn_quit.pressed.connect(_on_quit_pressed)
		if OS.has_feature("web"):
			btn_quit.visible = false
			
	# Hide all modal panels initially
	if how_to_play_panel:
		how_to_play_panel.visible = false
	if settings_panel:
		settings_panel.visible = false
	if credits_panel:
		credits_panel.visible = false

func _on_play_pressed() -> void:
	SceneTransition.change_scene("res://scenes/main.tscn")

func _on_how_to_play_pressed() -> void:
	_close_all_modals()
	if how_to_play_panel:
		how_to_play_panel.open_menu()

func _on_settings_pressed() -> void:
	_close_all_modals()
	if settings_panel:
		settings_panel.open_menu()

func _on_credits_pressed() -> void:
	_close_all_modals()
	if credits_panel:
		credits_panel.open_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _close_all_modals() -> void:
	if how_to_play_panel:
		how_to_play_panel.visible = false
	if settings_panel:
		settings_panel.visible = false
	if credits_panel:
		credits_panel.visible = false
