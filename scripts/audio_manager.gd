extends Node

# Procedural cozy audio synthesizer using AudioStreamGenerator
# Zero external sound files needed, completely self-contained and instant loading!

var sample_hz: float = 22050.0
var sfx_player: AudioStreamPlayer
var bgm_player: AudioStreamPlayer
var playback: AudioStreamGeneratorPlayback


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_audio_players()

func _setup_audio_players() -> void:
	# SFX Generator
	sfx_player = AudioStreamPlayer.new()
	var sfx_gen = AudioStreamGenerator.new()
	sfx_gen.mix_rate = sample_hz
	sfx_gen.buffer_length = 0.3
	sfx_player.stream = sfx_gen
	add_child(sfx_player)
	sfx_player.play()
	playback = sfx_player.get_stream_playback()

	# BGM Player
	bgm_player = AudioStreamPlayer.new()
	bgm_player.stream = load("res://assets/Audio/BGM.mp3")
	bgm_player.volume_db = -12.0
	add_child(bgm_player)
	bgm_player.play()

func _process(_delta: float) -> void:
	pass

# Plays a soft wooden 'pop' sound when placing an item or picking up
func play_pop(freq: float = 380.0) -> void:
	if not playback:
		return
	var frames_to_push = int(sample_hz * 0.08)
	for i in range(frames_to_push):
		var t = float(i) / sample_hz
		var env = exp(-t * 40.0)
		var pitch = freq * (1.0 - t * 5.0)
		var sample = sin(TAU * pitch * t) * env * 0.3
		playback.push_frame(Vector2(sample, sample))

# Plays a soft chime when an animal arrives or milestone is reached
func play_chime() -> void:
	if not playback:
		return
	var chords = [523.25, 659.25, 783.99, 1046.50] # C5, E5, G5, C6
	var frames_to_push = int(sample_hz * 0.3)
	for i in range(frames_to_push):
		var t = float(i) / sample_hz
		var env = exp(-t * 8.0)
		var sample: float = 0.0
		for f in chords:
			sample += sin(TAU * f * t)
		sample = (sample / float(chords.size())) * env * 0.25
		playback.push_frame(Vector2(sample, sample))

# Ambient soft wind & cozy music chords
# REMOVED: _fill_bgm_buffer functionality as BGM is now static MP3
