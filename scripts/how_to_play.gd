extends Control
class_name HowToPlayMenu

signal closed()

@onready var btn_back: Button = $PanelContainer/VBox/BtnBack

func _ready() -> void:
	if btn_back:
		btn_back.pressed.connect(close_menu)

func open_menu() -> void:
	visible = true

func close_menu() -> void:
	visible = false
	emit_signal("closed")
