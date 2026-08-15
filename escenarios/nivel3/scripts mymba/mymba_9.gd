extends CharacterBody3D

signal jugador_danado(id_yuyo: String)

@export var teclas_combo: Array[String] = ["interaccion", "ui_right", "ui_left"]
var pos_original: Vector3
var vel_normal: float = 14

@onready var jugador = $"../../karau"
@export var ojevy :  Marker3D
var SPEED = 12
var persigue = false
var volviendo_a_origen = false

@export var id_yuyo_esperado: String = ""

func _physics_process(delta: float) -> void:
	if volviendo_a_origen:
		if ojevy != null and is_instance_valid(ojevy):
			var direccion = ojevy.global_position - global_position
			direccion.y = 0
			if direccion.length() < 0.5:
				global_position = ojevy.global_position
				velocity = Vector3.ZERO
				volviendo_a_origen = false
			else:
				var angulo = atan2(direccion.x, direccion.z)
				rotation.y = lerp_angle(rotation.y, angulo, 5 * delta)
				direccion = direccion.normalized()
				velocity = direccion * SPEED
		else:
			global_position = pos_original
			velocity = Vector3.ZERO
			volviendo_a_origen = false
	elif persigue:

		var direccion = jugador.global_position - global_position
		var angulo = atan2(direccion.x, direccion.z)
		rotation.y = lerp_angle(rotation.y, angulo, 5 * delta)
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
	print("Enemigo [", name, "] recibio señal del yuyo: ", id)
	_reaccionar(id)


func _reaccionar(id: String) -> void:
	
	persigue = true
	$SonidoMykure.play()
func _ready() -> void:
	pos_original = global_position
	vel_normal = SPEED
	var area = get_node_or_null("Area3D")
	if area:
		if not area.body_entered.is_connected(_on_zona_daña_body_entered):
			area.body_entered.connect(_on_zona_daña_body_entered)

func _on_zona_daña_body_entered(body: Node3D) -> void:
	if persigue and (body.is_in_group("jugador_global") or body.is_in_group("jugon")):
		emit_signal("jugador_danado", id_yuyo_esperado)

func velocidad_reducida(reducir: bool) -> void:
	if reducir:
		SPEED = 1.5
	else:
		SPEED = vel_normal

func volver_a_origen() -> void:
	persigue = false
	velocidad_reducida(false)
	volviendo_a_origen = true
