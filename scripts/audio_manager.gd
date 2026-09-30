extends Node

# Centralized Audio Registry and Manager
# Supports both preloaded AudioStream and string keys (e.g. "pop", "click", "step", "main_menu")

const SOUNDS: Dictionary = {
	# SFX
	"pop": preload("res://assets/audio/Item Pop.wav"),
	"step": preload("res://assets/audio/SFX Grass Step.wav"),
	"water_splash": preload("res://assets/audio/Water Splash.wav"),
	"book_open": preload("res://assets/audio/Book Open.ogg"),
	"notification": preload("res://assets/audio/Notification.wav"),
	"click": preload("res://assets/audio/Button Click.wav"),
	"hover": preload("res://assets/audio/Button Hover.wav"),
	# Music
	"main_menu": preload("res://assets/audio/Main Menu BGM.mp3"),
	"autumn_bgm": preload("res://assets/audio/Autumn BGM.wav"),
	"bgm": preload("res://assets/audio/BGM.mp3")
}

var sfx_pool: Array[AudioStreamPlayer] = []
const POOL_SIZE: int = 8

var bgm_player: AudioStreamPlayer
var current_music_stream: AudioStream = null

# Procedural audio generator fallback
var sample_hz: float = 22050.0
var procedural_player: AudioStreamPlayer
var procedural_playback: AudioStreamGeneratorPlayback


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_buses()
	_setup_sfx_pool()
	_setup_bgm_player()
	_setup_procedural_player()


func _setup_audio_buses() -> void:
	# Ensure Music and SFX buses exist if not already configured in audio bus layout
	var _master_idx = AudioServer.get_bus_index("Master")
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		var music_idx = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(music_idx, "Music")
		AudioServer.set_bus_send(music_idx, "Master")
	
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		var sfx_idx = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(sfx_idx, "SFX")
		AudioServer.set_bus_send(sfx_idx, "Master")


func _setup_sfx_pool() -> void:
	for i in range(POOL_SIZE):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_pool.append(p)


func _setup_bgm_player() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music"
	add_child(bgm_player)
	bgm_player.finished.connect(_on_bgm_finished)


func _setup_procedural_player() -> void:
	procedural_player = AudioStreamPlayer.new()
	procedural_player.bus = "SFX"
	var sfx_gen = AudioStreamGenerator.new()
	sfx_gen.mix_rate = sample_hz
	sfx_gen.buffer_length = 0.3
	procedural_player.stream = sfx_gen
	add_child(procedural_player)
	procedural_player.play()
	procedural_playback = procedural_player.get_stream_playback()


func _on_bgm_finished() -> void:
	if current_music_stream != null and is_instance_valid(bgm_player):
		bgm_player.play()


## Play SFX with either an AudioStream resource or a registered String sound ID
func play_sfx(audio: Variant, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	var stream: AudioStream = _resolve_stream(audio)
	if not stream:
		return
	
	for p in sfx_pool:
		if not p.playing:
			p.stream = stream
			p.pitch_scale = pitch_scale
			p.volume_db = volume_db
			p.play()
			return
	
	# If all players are busy, steal the first one
	var fallback = sfx_pool[0]
	fallback.stop()
	fallback.stream = stream
	fallback.pitch_scale = pitch_scale
	fallback.volume_db = volume_db
	fallback.play()


## Play Music with either an AudioStream resource or a registered String sound ID
func play_music(audio: Variant, fade_duration: float = 0.5) -> void:
	var stream: AudioStream = _resolve_stream(audio)
	if not stream:
		return
	
	if current_music_stream == stream and bgm_player.playing:
		return
	
	current_music_stream = stream
	
	if fade_duration > 0.0 and bgm_player.playing:
		var tw = create_tween()
		tw.tween_property(bgm_player, "volume_db", -40.0, fade_duration)
		await tw.finished
	
	bgm_player.stream = stream
	bgm_player.volume_db = -4.0
	bgm_player.play()


## Stop Music
func stop_music() -> void:
	current_music_stream = null
	if bgm_player:
		bgm_player.stop()


## Set volume for Master, Music, or SFX buses (linear_vol from 0.0 to 1.0)
func set_volume(bus_name: String, linear_vol: float) -> void:
	var idx = AudioServer.get_bus_index(bus_name)
	if idx >= 0:
		if linear_vol <= 0.001:
			AudioServer.set_bus_mute(idx, true)
		else:
			AudioServer.set_bus_mute(idx, false)
			AudioServer.set_bus_volume_db(idx, linear_to_db(clamp(linear_vol, 0.001, 1.0)))


func _resolve_stream(audio: Variant) -> AudioStream:
	if audio is AudioStream:
		return audio
	elif audio is String and SOUNDS.has(audio):
		return SOUNDS[audio]
	return null


# Procedural sound backward-compatibility:
func play_pop(freq: float = 380.0) -> void:
	if not procedural_playback:
		return
	var frames_to_push = int(sample_hz * 0.08)
	for i in range(frames_to_push):
		var t = float(i) / sample_hz
		var env = exp(-t * 40.0)
		var pitch = freq * (1.0 - t * 5.0)
		var sample = sin(TAU * pitch * t) * env * 0.3
		procedural_playback.push_frame(Vector2(sample, sample))


func play_chime() -> void:
	if not procedural_playback:
		return
	var chords = [523.25, 659.25, 783.99, 1046.50]
	var frames_to_push = int(sample_hz * 0.3)
	for i in range(frames_to_push):
		var t = float(i) / sample_hz
		var env = exp(-t * 8.0)
		var sample: float = 0.0
		for f in chords:
			sample += sin(TAU * f * t)
		sample = (sample / float(chords.size())) * env * 0.25
		procedural_playback.push_frame(Vector2(sample, sample))
