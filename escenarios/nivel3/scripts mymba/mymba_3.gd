extends CharacterBody3D

@export var teclas_combo: Array[String] = ["ui_left", "ui_down", "interaccion"]
var pos_original: Vector3
var vel_normal: float = 14

@onready var jugador = $"../../karau"

@export var ojevy :  Marker3D
@export var id_yuyo_esperado: String = ""


var SPEED = 14
var persigue = false

func _ready() -> void:
	pos_original = global_position
	vel_normal = SPEED
func _physics_process(delta: float) -> void:
	$"ka'ilo/AnimationPlayer".play("corre")
	if persigue:
		var direccion = jugador.global_position - global_position
		var angulo = atan2(direccion.x,direccion.z)
		rotation.y = lerp_angle(rotation.y, angulo, 5 * delta)
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

func velocidad_reducida(reducir: bool) -> void:
	
	if reducir:
		SPEED = 0.5
	else:
		SPEED = vel_normal
	

func volver_a_origen() -> void:
	persigue = false

	velocidad_reducida(false)
	var direccion = ojevy.global_position - global_position
	var angulo = atan2(-direccion.x,direccion.z)
	rotation.y = lerp_angle(rotation.y, angulo,5)
	direccion = direccion.normalized()
	velocity = direccion * SPEED
	
	move_and_slide()
	
	
	
	
	
