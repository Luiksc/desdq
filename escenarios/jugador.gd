extends CharacterBody3D




var velo_max : float = 11
var distans_salto: float = 2.5 
var timp_salto: float= 0.3
var aceleracion: float= 7
var friccion:float= 50
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var fuerza_salto : float
var gravedad : float

var estuvo_suelo: bool = true
var puede_moverse: bool = true
var mouse_cam: bool= true #bloquea la camara al presionar escape

@export var tiem_jump_buffer: float = 0.15
@export var tiem_coyote: float = 0.15


	


func _ready() -> void:
	fuerza_salto = (2 * distans_salto) / timp_salto
	gravedad = (-2 * distans_salto) / (timp_salto * timp_salto)
	
	

func _physics_process(delta: float) -> void: #se comprueba 60 veces por segundo, siendo un bucle
	moviminto(delta)
	move_and_slide()
	
func saltar():
	velocity.y = fuerza_salto


func moviminto(delta: float) -> void:
	# Gravedad siempre activa (aunque no pueda moverse, para que no flote)
	if not is_on_floor():
		velocity.y += gravedad * delta
		velocity.y = max(velocity.y, gravedad * 3) # limite de caida

	# Si el movimiento está bloqueado (ej: durante un diálogo), frenar y salir
	if not puede_moverse:
		velocity.x = move_toward(velocity.x, 0, friccion * delta)
		velocity.z = move_toward(velocity.z, 0, friccion * delta)
		return

	#   DIRECCION con input
	var input_direccion := Vector3.ZERO
	input_direccion.x = Input.get_axis("ui_left", "ui_right")
	input_direccion.z = Input.get_axis("ui_up", "ui_down")
	input_direccion = input_direccion.normalized() # normaliza y regulariza movement

	# coyote time
	# estuvo_suelo se actualiza cada frame: true si está en suelo false si está en aire
	if is_on_floor():
		estuvo_suelo = true
		coyote_timer = tiem_coyote  # recarga el timer mientras está en suelo
	elif estuvo_suelo:
		# acaba de salir del suelo sin saltar -> activar ventana coyote
		estuvo_suelo = false
		# el timer ya está cargado desde el frame anterior
	if coyote_timer > 0:
		coyote_timer -= delta
	var salto_posible = is_on_floor() or coyote_timer > 0

	# JUMP BUFFER
	# Registra la intención de salto aunque el jugador no esté en suelo aún
	if Input.is_action_pressed("saltar"):
		jump_buffer_timer = tiem_jump_buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if salto_posible and jump_buffer_timer > 0:
		saltar()
		jump_buffer_timer = 0
		coyote_timer = 0

	#   MOVIMIENTO horizontal
	if input_direccion.length() > 0.1:
		var direction = (transform.basis * input_direccion)
		direction.y = 0
		direction = direction.normalized()
		var target_velocity = direction * velo_max
		var velo_horizontal = Vector3(velocity.x, 0, velocity.z)
		var cambio_direccion = velo_horizontal.dot(direction) < 0.0
		var aceleracion_actual = friccion if cambio_direccion else aceleracion

		velocity.x = move_toward(velocity.x, target_velocity.x, aceleracion_actual * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, aceleracion_actual * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friccion * delta)
		velocity.z = move_toward(velocity.z, 0, friccion * delta)
		
		



		
