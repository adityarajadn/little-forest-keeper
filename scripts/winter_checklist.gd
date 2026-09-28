extends Control
class_name ChecklistModal

signal winter_accepted()

@onready var food_check: Label = $PanelContainer/VBoxContainer/GridContainer/FoodCheck
@onready var water_check: Label = $PanelContainer/VBoxContainer/GridContainer/WaterCheck
@onready var plants_check: Label = $PanelContainer/VBoxContainer/GridContainer/PlantsCheck
@onready var shelter_check: Label = $PanelContainer/VBoxContainer/GridContainer/ShelterCheck
@onready var animal_check: Label = $PanelContainer/VBoxContainer/GridContainer/AnimalCheck
@onready var btn_winter: Button = $PanelContainer/VBoxContainer/BtnTriggerWinter
@onready var btn_close: Button = $PanelContainer/VBoxContainer/BtnClose

var all_ready: bool = false
var missing_info: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if btn_close:
		btn_close.pressed.connect(close_checklist)
	if btn_winter:
		btn_winter.pressed.connect(_on_trigger_winter)

func open_checklist() -> void:
	visible = true

func close_checklist() -> void:
	visible = false

func update_status(food_count: int, water_count: int, plant_count: int, shelter_count: int, animal_count: int) -> void:
	var f_ok = food_count >= 3
	var w_ok = water_count >= 1
	var p_ok = plant_count >= 3
	var s_ok = shelter_count >= 1
	var a_ok = animal_count >= 3

	food_check.text = "%s Food Supply (%d/3)" % ["✓" if f_ok else "✗", food_count]
	water_check.text = "%s Water Source (%d/1)" % ["✓" if w_ok else "✗", water_count]
	plants_check.text = "%s Plants (%d/3)" % ["✓" if p_ok else "✗", plant_count]
	shelter_check.text = "%s Nests (%d/1)" % ["✓" if s_ok else "✗", shelter_count]
	animal_check.text = "%s Animals (%d/3)" % ["✓" if a_ok else "✗", animal_count]

	all_ready = f_ok and w_ok and p_ok and s_ok and a_ok

	var missing: Array[String] = []
	if not f_ok: missing.append("Food/Acorns (%d/3)" % food_count)
	if not w_ok: missing.append("Water Source (%d/1)" % water_count)
	if not p_ok: missing.append("Plants (%d/3)" % plant_count)
	if not s_ok: missing.append("Nests (%d/1)" % shelter_count)
	if not a_ok: missing.append("Animals (%d/3)" % animal_count)
	missing_info = ", ".join(missing)

	btn_winter.disabled = false
	if all_ready:
		btn_winter.text = "Welcome Winter! (Ready)"
	else:
		btn_winter.text = "Welcome Winter (Requirements Incomplete)"

func _on_trigger_winter() -> void:
	if not all_ready:
		var gm = get_node_or_null("/root/Main/GameManager")
		if gm:
			gm.status_message.emit("Not ready! Still missing: " + missing_info)
		return
	close_checklist()
	winter_accepted.emit()
