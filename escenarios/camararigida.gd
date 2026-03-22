extends Node3D

# Arrastrá tu jugador aquí desde el editor
@export var offset: Vector3 = Vector3(0, 5, 8)
@export var velocidad_seguimiento: float = 10.0
@onready var jugador: CharacterBody3D= get_node("../jugador")

func _ready() -> void:
	# Busca el jugador automáticamente, sin necesidad de asignarlo en el editor
	if jugador == null:
		jugador = get_tree().get_first_node_in_group("jugador")
	
	if jugador != null:
		global_position = jugador.global_position + offset
		look_at(jugador.global_position, Vector3.UP)
	else:
		push_error("CameraRig: no se encontró el jugador")
func _process(delta: float) -> void:
	
	if jugador == null:
		jugador = get_tree().get_first_node_in_group("jugador")
		
	var target_pos = jugador.global_position + offset
	global_position = global_position.lerp(target_pos, velocidad_seguimiento * delta)
	
	
	# La rotación NUNCA cambia: la cámara siempre mira en la misma dirección
	# Si querés que siempre apunte al jugador descomentá la siguiente línea:
	# look_at(jugador.global_position, Vector3.UP)
