extends Node3D

## Script individual de cada cápsula que actúa como "receptor" de la señal
## del yuyo instanciado que le corresponde según su spawn point.

## Identificador del yuyo que esta cápsula puede recibir.
## Se asigna desde ka'arurupa.gd al momento del spawn.
@export var id_yuyo_esperado: String = ""

## Referencia al yuyo instanciado (se asigna desde el script de nivel)
var yuyo_instancia: Node3D = null

## Se llama desde el script del nivel para vincular esta cápsula con un yuyo.
func vincular_yuyo(yuyo: Node3D) -> void:
	yuyo_instancia = yuyo
	# Conectar la señal del yuyo a esta cápsula
	if yuyo_instancia.has_signal("jugador_entro"):
		if not yuyo_instancia.jugador_entro.is_connected(_on_yuyo_recibido):
			yuyo_instancia.jugador_entro.connect(_on_yuyo_recibido)

## Se dispara cuando el jugador entra al área del yuyo vinculado.
func _on_yuyo_recibido(id: String) -> void:
	print("Capsula [", name, "] recibio señal del yuyo: ", id)
	# Aquí podés agregar lógica específica por cápsula:
	# animar, iluminar, actualizar UI, etc.
	_reaccionar(id)

## Reacción visual/lógica de la cápsula al recibir la señal.
func _reaccionar(id: String) -> void:
	# Ejemplo: ocultar la cápsula cuando el yuyo fue recogido
	hide()
