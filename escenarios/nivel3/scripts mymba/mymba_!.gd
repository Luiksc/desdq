extends CharacterBody3D

@export var teclas_combo: Array[String] = ["interaccion", "ui_up", "ui_right"]
var pos_original: Vector3
var vel_normal: float = 14

@onready var jugador = $"../../karau"
@export var ojevy : Marker3D
var SPEED = 10

var persigue = false

@export var id_yuyo_esperado: String = ""

func _ready() -> void:
	pos_original = global_position
	vel_normal = SPEED

var yuyo_instancia: Node3D = null

func _physics_process(delta: float) -> void:
	if persigue:
		var direccion = jugador.global_position - global_position
		direccion.y = 0
		direccion = direccion.normalized()
		velocity = direccion * SPEED
	move_and_slide()

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

func velocidad_reducida(reducir: bool) -> void:
	if reducir:
		SPEED = 0.5
	else:
		SPEED = vel_normal


func volver_a_origen() -> void:
	persigue = false
	
	velocidad_reducida(false)
	var direccion = ojevy.global_position - global_position
	direccion = direccion.normalized()
	velocity = direccion * SPEED
	move_and_slide()
	
