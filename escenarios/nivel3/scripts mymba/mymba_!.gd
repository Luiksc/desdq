extends CharacterBody3D

signal jugador_danado(id_yuyo: String)

@export var teclas_combo: Array[String] = ["interaccion", "ui_up", "ui_right"]
var pos_original: Vector3
var vel_normal: float = 15

@onready var jugador = $"../../karau"
@export var ojevy : Marker3D
var SPEED = 19

var persigue = false
var volviendo_a_origen = false

@export var id_yuyo_esperado: String = ""

func _ready() -> void:
	pos_original = global_position
	vel_normal = SPEED
	var area = get_node_or_null("Area3D")
	if area:
		if not area.body_entered.is_connected(_on_zona_daña_body_entered):
			area.body_entered.connect(_on_zona_daña_body_entered)

var yuyo_instancia: Node3D = null

func _on_zona_daña_body_entered(body: Node3D) -> void:
	if persigue and (body.is_in_group("jugador_global") or body.is_in_group("jugon")):
		emit_signal("jugador_danado", id_yuyo_esperado)

func _physics_process(delta: float) -> void:
	$"ka'ilo/AnimationPlayer".play("corre")
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
				direccion.y = 0
				velocity = direccion * vel_normal
		else:
			global_position = pos_original
			velocity = Vector3.ZERO
			volviendo_a_origen = false
	elif persigue:
		
		var direccion = jugador.global_position - global_position
		var angulo = atan2(direccion.x,direccion.z)
		rotation.y = lerp_angle(rotation.y, angulo, 5 * delta)
		direccion.y = 0
		direccion = direccion.normalized()
		velocity = direccion * SPEED
		$MonkeyScream2.play()
	move_and_slide()

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
	$MonkeyScream3.play()

func velocidad_reducida(reducir: bool) -> void:
	if reducir:
		SPEED = 0.5
	else:
		SPEED = vel_normal


func volver_a_origen() -> void:
	persigue = false
	velocidad_reducida(false)
	volviendo_a_origen = true
