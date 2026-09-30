extends CanvasLayer

@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var transition: Node = $FadeOverlay/GuiTransition

var is_transitioning: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 120
	if fade_overlay:
		fade_overlay.visible = false
		fade_overlay.modulate.a = 0.0
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(scene_path: String) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	get_tree().paused = false
	
	if fade_overlay:
		fade_overlay.visible = true
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if GuiTransitions and GuiTransitions.has_method("show"):
		GuiTransitions.show("SceneFade")
		await GuiTransitions.show_completed
	else:
		await _fallback_fade(0.0, 1.0, 0.4)
	
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await get_tree().process_frame
	
	if GuiTransitions and GuiTransitions.has_method("hide"):
		GuiTransitions.hide("SceneFade")
		await GuiTransitions.hide_completed
	else:
		await _fallback_fade(1.0, 0.0, 0.4)
	
	if fade_overlay:
		fade_overlay.visible = false
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_transitioning = false

func reload_scene() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	get_tree().paused = false
	
	if fade_overlay:
		fade_overlay.visible = true
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if GuiTransitions and GuiTransitions.has_method("show"):
		GuiTransitions.show("SceneFade")
		await GuiTransitions.show_completed
	else:
		await _fallback_fade(0.0, 1.0, 0.4)
	
	get_tree().reload_current_scene()
	await get_tree().process_frame
	await get_tree().process_frame
	
	if GuiTransitions and GuiTransitions.has_method("hide"):
		GuiTransitions.hide("SceneFade")
		await GuiTransitions.hide_completed
	else:
		await _fallback_fade(1.0, 0.0, 0.4)
	
	if fade_overlay:
		fade_overlay.visible = false
		fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_transitioning = false

func _fallback_fade(from_a: float, to_a: float, dur: float) -> void:
	if not fade_overlay:
		return
	var tw = create_tween()
	tw.tween_property(fade_overlay, "modulate:a", to_a, dur).from(from_a)
	await tw.finished
