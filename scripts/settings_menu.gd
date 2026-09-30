extends Control
class_name SettingsMenu

signal closed()

@onready var slider_master: HSlider = $PanelContainer/VBox/AudioSection/MasterContainer/SliderMaster
@onready var slider_music: HSlider = $PanelContainer/VBox/AudioSection/MusicContainer/SliderMusic
@onready var slider_sfx: HSlider = $PanelContainer/VBox/AudioSection/SFXContainer/SliderSFX

@onready var label_master: Label = $PanelContainer/VBox/AudioSection/MasterContainer/ValMaster
@onready var label_music: Label = $PanelContainer/VBox/AudioSection/MusicContainer/ValMusic
@onready var label_sfx: Label = $PanelContainer/VBox/AudioSection/SFXContainer/ValSFX

@onready var check_fullscreen: CheckBox = $PanelContainer/VBox/DisplaySection/CheckFullscreen
@onready var btn_back: Button = $PanelContainer/VBox/BtnBack

func _ready() -> void:
	if btn_back:
		btn_back.pressed.connect(close_menu)
		
	if slider_master:
		slider_master.value_changed.connect(_on_master_changed)
	if slider_music:
		slider_music.value_changed.connect(_on_music_changed)
	if slider_sfx:
		slider_sfx.value_changed.connect(_on_sfx_changed)
		
	if check_fullscreen:
		check_fullscreen.toggled.connect(_on_fullscreen_toggled)
		var is_fs = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
		check_fullscreen.set_pressed_no_signal(is_fs)

func open_menu() -> void:
	visible = true

func close_menu() -> void:
	visible = false
	emit_signal("closed")

func _on_master_changed(val: float) -> void:
	if label_master:
		label_master.text = "%d%%" % int(val)
	AudioManager.set_volume("Master", val / 100.0)

func _on_music_changed(val: float) -> void:
	if label_music:
		label_music.text = "%d%%" % int(val)
	AudioManager.set_volume("Music", val / 100.0)

func _on_sfx_changed(val: float) -> void:
	if label_sfx:
		label_sfx.text = "%d%%" % int(val)
	AudioManager.set_volume("SFX", val / 100.0)

func _set_bus_volume(bus_name: String, val: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		if val <= 0.0:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
			var db = linear_to_db(val / 100.0)
			AudioServer.set_bus_volume_db(bus_idx, db)

func _on_fullscreen_toggled(is_toggled: bool) -> void:
	if is_toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
