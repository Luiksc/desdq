extends Node

var final_n1 : bool= false

var kapanga_persiguiendo : Node = null
var jugador_inmune_kapanga : bool = false
var timer_inmunidad_kapanga : Timer = null

func _ready() -> void:
	timer_inmunidad_kapanga = Timer.new()
	timer_inmunidad_kapanga.wait_time = 4.0
	timer_inmunidad_kapanga.one_shot = true
	timer_inmunidad_kapanga.name = "TimerInmunidadKapanga"
	timer_inmunidad_kapanga.timeout.connect(_on_timer_inmunidad_timeout)
	add_child(timer_inmunidad_kapanga)

func activar_inmunidad_kapanga(duracion: float = 4.0) -> void:
	jugador_inmune_kapanga = true
	timer_inmunidad_kapanga.start(duracion)

func _on_timer_inmunidad_timeout() -> void:
	jugador_inmune_kapanga = false

func reset_kapanga_state() -> void:
	kapanga_persiguiendo = null
	jugador_inmune_kapanga = false
	if timer_inmunidad_kapanga != null and not timer_inmunidad_kapanga.is_stopped():
		timer_inmunidad_kapanga.stop()

