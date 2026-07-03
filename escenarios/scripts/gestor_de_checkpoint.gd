extends Node

var jugador
var ultima_posicion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jugador = get_parent().get_node("jugador")
	ultima_posicion=jugador.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
