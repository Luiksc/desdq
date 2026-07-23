extends AudioStreamPlayer

const musica_n3 = preload("res://audios/Tupã Rekoy.mp3")

func play_music(music:AudioStream, volume = -15):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()
	
func play_music_level ():
	play_music(musica_n3)
