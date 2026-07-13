extends CharacterBody3D

@onready var jugador = $"../../karau"
var SPEED = 8
var persigue = false

@export var id_yuyo_esperado: String = ""

func _physics_process(delta: float) -> void:
	if persigue:
		var direccion = jugador.global_position - global_position
		direccion.y = 0
		direccion = direccion.normalized()
		velocity = direccion * SPEED
	move_and_slide()
var yuyo_instancia: Node3D = null


func vincular_yuyo(yuyo: Node3D) -> void:
	yuyo_instancia = yuyo

	if yuyo_instancia.has_signal("jugador_entro"):
		if not yuyo_instancia.jugador_entro.is_connected(_on_yuyo_recibido):
			yuyo_instancia.jugador_entro.connect(_on_yuyo_recibido)


func _on_yuyo_recibido(id: String) -> void:
	print("Capsula [", name, "] recibio señal del yuyo: ", id)

	_reaccionar(id)


func _reaccionar(id: String) -> void:
	
	persigue = true
