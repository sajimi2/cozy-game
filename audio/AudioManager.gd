extends Node

@export var is_muted: bool = false

@export var main_songs = [] # (Array, AudioStream)

var last_main_music_position = 0.0
var last_minigame_music_position = 0.0

func play_ambient(song_name):
	if is_muted:
		return
	for song in $Ambient.get_children():
		if song.name == song_name and !song.playing:
			song.play()

func stop_all_ambient():
	for song in $Ambient.get_children():
		if song.playing:
			song.stop()

func play_main_music():
	var next_song_name = "MainMusic_%d" % (Globals.get_progress_level() + 1)
	play_song(next_song_name)

func stop_all_songs():
	for song in $Music.get_children():
		if song.playing:
			if "MainMusic" in song.name:
				last_main_music_position = song.get_playback_position()
			elif "Minigame" in song.name:
				last_minigame_music_position = song.get_playback_position()
			song.stop()

func play_song(song_name):
	if is_muted:
		return
	for song in $Music.get_children():
		if song.name == song_name and !song.playing:
			stop_all_songs()
			if "MainMusic" in song.name:
				song.play(last_main_music_position)
			elif "Minigame" in song.name:
				song.play()
			else:
				song.play()

func play_sfx(sound_name):
	if is_muted:
		return
	for sound_manager in $Sounds.get_children():
		for sound in sound_manager.get_children():
			if sound.name == sound_name:
				sound.play()
