extends Node

const CLICK_SFX = preload("res://assets/audio/Button Click.wav")
const HOVER_SFX = preload("res://assets/audio/Button Hover.wav")

func _ready():
	_connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node):
	if node is Button:
		_setup_button(node)

func _connect_buttons(root):
	for node in root.get_children():
		if node is Button:
			_setup_button(node)
		_connect_buttons(node)

func _setup_button(btn: Button):
	btn.pressed.connect(func(): AudioManager.play_sfx(CLICK_SFX))
	btn.mouse_entered.connect(func(): AudioManager.play_sfx(HOVER_SFX))
