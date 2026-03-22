extends CharacterBody3D

var velo_max : float = 8
var distans_salto: float = 2.5 #metros
var timp_salto: float= 0.3#segundos
var aceleracion: float= 7
var friccion:float= 20
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var estuvo_suelo: bool = true

@export var tiem_jump_buffer: float = 0.25
@export var tiem_coyote:float = 1

var fuerza_salto : float
var gravedad : float
#onready porque son variable creadas anteriormente
func _ready() -> void:
	fuerza_salto = (2 * distans_salto) / timp_salto
	gravedad = (-2 * distans_salto) / (timp_salto * timp_salto)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta: float) -> void: #se comprueba 60 veces por segundo, siendo un bucle
	moviminto(delta)
	move_and_slide()
	mouse_appear()
func saltar():
	velocity.y = fuerza_salto

func moviminto(delta: float) ->void:
#   DIIRECCION con input
	var input_direccion := Vector3.ZERO
	input_direccion.x = Input.get_axis("ui_left", "ui_right")
	input_direccion.z = Input.get_axis("ui_up","ui_down")
	input_direccion = input_direccion.normalized() #normaliza y regulariza movement
	
	# COYOTE TEIMPO
	if estuvo_suelo and not is_on_floor():
		coyote_timer = tiem_coyote
		estuvo_suelo = is_on_floor()
	if coyote_timer > 0:
		coyote_timer -= delta
		
	var salto_posible = is_on_floor() or coyote_timer>0
	
#   salto con buffer
	if Input.is_action_just_pressed("saltar"):
		jump_buffer_timer=tiem_jump_buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		
	if salto_posible and jump_buffer_timer> 0 :
		saltar()
		jump_buffer_timer = 0
		coyote_timer = 0
#   MOVIMIENTO horizontal
	if input_direccion.length() > 0.1:
		var direction = (transform.basis * input_direccion)
		direction.y = 0
		direction = direction.normalized()
		var target_velocity = direction * velo_max  
		var velo_horizontal= Vector3(velocity.x, 0, velocity.z)
		var cambio_direccion = velo_horizontal.dot(direction) < 0.0
		var aceleracion_actual = friccion if cambio_direccion else aceleracion
		
		velocity.x = move_toward(velocity.x, target_velocity.x, aceleracion_actual * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, aceleracion_actual * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friccion * delta)
		velocity.z = move_toward(velocity.z, 0, friccion * delta)

	#gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta
		velocity.y = max(velocity.y, gravedad * 3) #pone un limite de caida
func mouse_appear() -> void:
	if Input.is_action_just_pressed("escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED




		
