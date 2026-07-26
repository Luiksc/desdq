extends Node3D


@export var id_yuyo_esperado: String = ""


var yuyo_instancia: Node3D = null


func vincular_yuyo(yuyo: Node3D) -> void:
	yuyo_instancia = yuyo

	if yuyo_instancia.has_signal("jugador_entro"):
		if not yuyo_instancia.jugador_entro.is_connected(_on_yuyo_recibido):
			yuyo_instancia.jugador_entro.connect(_on_yuyo_recibido)

## Se dispara cuando el jugador entra al área del yuyo vinculado.
func _on_yuyo_recibido(id: String) -> void:
	print("Enemigo [", name, "] recibio señal del yuyo: ", id)

	_reaccionar(id)


func _reaccionar(id: String) -> void:
	
	hide()
