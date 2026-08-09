extends AudioStreamPlayer


const MUSICA_N3 = preload("res://audios/Tupã Rekoy.mp3")
const jui_ambiente = preload("res://audios/sonidos_ambiente/Sonidos de juí.mp3")
const tortola_ambiente = preload("res://audios/sonidos_ambiente/Tórtola o Rabiche Cantando Sonido para Llamar El Mejor.mp3")
const MUSICA_KARAU = preload("res://audios/musica de nivel/El karau - Quemil Yambay letra'y.mp3")
const MUSICA_MENSU = preload("res://audios/musica de nivel/El mensú (Juan Saucedo) Letra'y.mp3")
const musica_mateo = preload("res://audios/musica de nivel/Mateo-gamarra-Duo-Quintana-letra_yme.mp3")

# ── Función base (no llamar directamente desde los niveles) ─────────────────
func play_music(music: AudioStream, volume: float = -16.0) -> void:
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

# ── Stop ────────────────────────────────────────────────────────────────────
func detener_musica() -> void:
	stop()

# ── Funciones nombradas por uso ─────────────────────────────────────────────

# Música de fondo del nivel 3 (Tupã Rekoy)
func musica_fondo_nivel3() -> void:
	play_music(MUSICA_N3)

# Música cinemática / llegada
func jui_sonido_ambiental() -> void:
	play_music(jui_ambiente)

# Polkas (menú o pantalla de inicio)
func tortola_sonido_ambiente() -> void:
	play_music(tortola_ambiente)

# Música de nivel: El karau
func musica_fondo_karau() -> void:
	play_music(MUSICA_KARAU)

# Música de nivel: El mensú
func musica_fondo_mensu() -> void:
	play_music(MUSICA_MENSU)

# Música de nivel: Mateo Gamarra
func musica_fondo_mateo() -> void:
	play_music(musica_mateo)

# ── Alias de compatibilidad (mantiene el nombre original funcionando) ────────
func play_music_level() -> void:
	musica_fondo_nivel3()
