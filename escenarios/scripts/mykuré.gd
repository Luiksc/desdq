extends CharacterBody3D

var jugador
var triger_mykure
var puede_espantar :bool = false
var SPEED = 17
@export var inicio :Marker3D
@export var punto_retiro :Marker3D
enum estado{
	esperando,
	persiguiendo,
	retirada
	}

var Estado = estado.esperando

func _ready() -> void:
	show()
	jugador = $"../jugador"
	triger_mykure= $"../triggers/Mykure_trigger"
	

func _physics_process(delta: float) -> void:

	match Estado:
		estado.esperando:
			velocity= Vector3.ZERO
			
		estado.persiguiendo:
			var direccion = jugador.global_position - global_position
			direccion.y = 0
			direccion = direccion.normalized()
			velocity = direccion*SPEED
			move_and_slide()
			
		estado.retirada:
		
			var direccion = (punto_retiro.global_position-global_position)
			direccion= direccion.normalized()
			direccion.y = 0
			velocity = direccion * SPEED
			move_and_slide()
			if global_position.distance_to(punto_retiro.global_position) < 0.5:
				hide()



	
	if Input.is_action_just_pressed("interaccion") and puede_espantar:
		detenido_sape()


func _on_mykure_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global"):
		puede_espantar=true
		Estado = estado.persiguiendo
		
		
func detenido_sape():
	Estado = estado.retirada
	triger_mykure.queue_free()
	
func _on_area_3d_daña_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global"):
		Estado = estado.esperando
		reinicio()
func reinicio():
	Estado = estado.esperando
	velocity = Vector3.ZERO
	global_position= inicio.global_position
	show()
	puede_espantar=false
