@tool
extends Node

enum BusType {
	SFX,
	MUSIC,
	MASTER
}

@export var audio_files: Array[AudioStream] = []: set = set_audio_files
@export var volume_db = 0.0: set = set_volume_db
@export var pitch_scale = 1.0: set = set_pitch_scale
@export var pitch_randomness = 0.0  # (float, 0.0, 1.0)
@export var play_sample: bool = false: set = set_play_sample
@export var audio_bus_name: BusType = BusType.SFX: set = set_audio_bus_name
@export var max_sounds_playing = 5 # (int, 1, 20)
@export var skip_frequency = 1 # (int, 1, 100)
@export var delay_offset_ms: float = 0.0
@export var random_delay_range_ms: float = 0.0
@export var randomized_order: bool = false
@export var allow_duplicate_sounds_playing: bool = true

var SeenSoundIndexes = []
var LastPlayedSoundIndex = -1
var CalledCount = 0

func set_audio_files(_audio_files):
	audio_files = _audio_files

func set_audio_bus_name(_audio_bus_name):
	audio_bus_name = _audio_bus_name
	update_audio_buses()

func set_play_sample(should_play_sample):
	play()

func set_volume_db(vol_db):
	volume_db = vol_db
	for player in get_children():
		player.volume_db = vol_db

func set_pitch_scale(_pitch_scale):
	pitch_scale = _pitch_scale
	for player in get_children():
		player.pitch_scale = _pitch_scale

func _ready():
	update_audio_buses()

func update_audio_buses():
	var _audio_bus_name = "Master"
	match audio_bus_name:
		BusType.MUSIC:
			_audio_bus_name = "Music"
		BusType.SFX:
			_audio_bus_name = "SFX"
		_:
			_audio_bus_name = "Master"
	if AudioServer.get_bus_index(_audio_bus_name) != -1:
		for audio_player in get_children():
			audio_player.set_bus(_audio_bus_name)

func play():
	if !audio_files or len(audio_files) == 0:
		return
	CalledCount += 1
	if skip_frequency > 1 and CalledCount % skip_frequency != 0:
		return
	var next_audio_stream_player = get_next_audio_stream_player()
	next_audio_stream_player.stream = get_next_sound()
	if !allow_duplicate_sounds_playing and is_sound_already_playing(next_audio_stream_player.stream):
		return
	else:
		if pitch_randomness > 0.0:
			randomize()
			var plus_minus = 1.0 if randi() % 2 == 0 else -1.0
			randomize()
			next_audio_stream_player.pitch_scale = pitch_scale + randf_range(0.0, pitch_randomness) * plus_minus
		elif pitch_randomness == 0.0:
			next_audio_stream_player.pitch_scale = pitch_scale
		if delay_offset_ms > 0:
			if random_delay_range_ms > 0.0:
				randomize()
				var random_delay_offset = randf_range(-random_delay_range_ms/2.0, random_delay_range_ms/2.0)
			await get_tree().create_timer((delay_offset_ms + random_delay_range_ms) / 1000.0).timeout
		next_audio_stream_player.play()

func stop():
	for audio_player in get_children():
		audio_player.stop()

func is_sound_already_playing(_stream):
	for sound in get_children():
		if sound.stream == _stream and sound.playing:
			return true
	return false

func get_next_audio_stream_player():
	for i in range(0, max_sounds_playing):
		var next_child = get_child(i)
		if !next_child.playing:
			return next_child
	return get_child(0)

func get_next_sound():
	if len(audio_files) == 1:
		return audio_files[0]
	if len(SeenSoundIndexes) == len(audio_files):
		SeenSoundIndexes.clear()
	if randomized_order:
		var rand_index = randi() % len(audio_files)
		while rand_index in SeenSoundIndexes or (len(audio_files) > 2 and rand_index == LastPlayedSoundIndex):
			randomize()
			rand_index = randi() % len(audio_files)
		var rand_note = audio_files[rand_index]
		LastPlayedSoundIndex = rand_index
		SeenSoundIndexes.push_back(rand_index)
		return rand_note
	else:
		var next_index = len(SeenSoundIndexes)
		var next_note = audio_files[next_index]
		SeenSoundIndexes.push_back(next_index)
		return next_note
