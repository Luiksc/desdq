extends CharacterBody3D

signal combo
   
@onready var pivote: Node3D = $pivote
@onready var piel: Node3D = $karau
@onready var anima_karau : AnimationPlayer =  $karau/AnimationPlayer  # nodo de la cámara 
@onready var camara_contro = $pivote

@export var vel_rotacion: float  # qué tan rápido rota el personaje

var mymba_en_combo: Node3D = null
var teclas_faltantes: Array[String] = []
var posibles_acciones = ["ui_up", "ui_down", "ui_left", "ui_right", "interaccion", "saltar"]
var ui_combo_nodos: Dictionary = {}
var combo_delay_timer: float = 0.0  # Tiempo de espera antes de detectar teclas en el combo
const COMBO_INPUT_DELAY: float = 0.2  # Segundos de delay al inicio del combo
var farra := false:
	set(value):
		farra = value
		if value and is_inside_tree():
			camara_contro.posiciona()
var anima_activo = true
var velo_max : float = 10
var distans_salto: float = 2.5 
var timp_salto: float= 0.3
var aceleracion: float= 50
var friccion:float= 100
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var fuerza_salto : float
var gravedad : float

var estuvo_suelo: bool = true
var puede_moverse: bool = true
var mouse_cam: bool= true #bloquea la camara al presionar escape
var input_direccion := Vector3.ZERO

@export var tiem_jump_buffer: float = 0.15
@export var tiem_coyote: float = 0.15

const  LERP_VAL = .15
	

func _ready() -> void:

	fuerza_salto = (2 * distans_salto) / timp_salto
	gravedad = (-2 * distans_salto) / (timp_salto * timp_salto)
	anima_activo= true
	anima_karau.play("repira")
	
	# Buscar los nodos AnimatedSprite2D para el combo y ocultarlos inicialmente
	var root = get_tree().get_root()
	for accion in posibles_acciones:
		var nodo_sprite = root.find_child(accion, true, false)
		if nodo_sprite and nodo_sprite is AnimatedSprite2D:
			ui_combo_nodos[accion] = nodo_sprite
			nodo_sprite.hide()
			nodo_sprite.frame = 0


func _physics_process(delta: float) -> void: #se comprueba 60 veces por segundo, siendo un bucle
	
	if mymba_en_combo != null:
		if combo_delay_timer > 0:
			combo_delay_timer -= delta
		else:
			procesar_combo()
	
	moviminto(delta)
	move_and_slide()
	
	# Solo cambiar animación si el movimiento está activo (para no pisar animaciones cinemáticas)
	if puede_moverse:
		if input_direccion.length() > 0.1:
			anima_karau.play("oho")

		else:
			anima_karau.play("repira")

	
func saltar():
	velocity.y = fuerza_salto


func moviminto(delta: float) -> void:
	# Gravedad siempre activa (aunque no pueda moverse para que no flote)
	if not is_on_floor():
		velocity.y += gravedad * delta
		velocity.y = max(velocity.y, gravedad * 3) # limite de caida

	# Si el movimiento está bloqueado, frenar y salir
	if not puede_moverse:
		velocity.x = move_toward(velocity.x, 0, friccion * delta)
		velocity.z = move_toward(velocity.z, 0, friccion * delta)
		return

	#   DIRECCION con input
	if farra == false:
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
	if Input.is_action_just_pressed("saltar"):
		jump_buffer_timer = tiem_jump_buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if salto_posible and jump_buffer_timer > 0:
		saltar()
		jump_buffer_timer = 0
		coyote_timer = 0

	#   MOVIMIENTO horizontal
	if input_direccion.length() > 0.1:
		# Dirección relativa a la cámara (pivote), ignorando la rotación del cuerpo
		var direccion = (pivote.global_transform.basis * input_direccion)
		direccion.y = 0
		direccion = direccion.normalized()
		piel.rotation.y= lerp_angle(piel.rotation.y, (atan2(direccion.x, direccion.z))+ 3*PI/2, LERP_VAL)
		# este codigo espera que el modelo mire hacia la direccion z, el modelo esta mal y entonces se compensa
		#con una rotacion de 3*PI/2 que son 270° en radianes
			
			

		# Rotar
		#var angulo_destino = atan2(direccion.x, direccion.z)
		
		

		var target_velocity = direccion * velo_max
		var velo_horizontal = Vector3(velocity.x, 0, velocity.z)
		var cambio_direccion = velo_horizontal.dot(direccion) < 0.0
		var aceleracion_actual = friccion if cambio_direccion else aceleracion


		velocity.x = move_toward(velocity.x, target_velocity.x, aceleracion_actual * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, aceleracion_actual * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friccion * delta)
		velocity.z = move_toward(velocity.z, 0, friccion * delta)





func _on_final_body_entered(body: Node3D) -> void:
	puede_moverse = false
	


func _on_combo_body_entered(body: Node3D) -> void:
	if body.is_in_group("mymba") and mymba_en_combo == null:
		mymba_en_combo = body
		
		# Leer teclas combo del mymba o usar un valor por defecto
		if "teclas_combo" in body:
			teclas_faltantes = body.teclas_combo.duplicate()
		else:
			teclas_faltantes = ["interaccion", "ui_up", "ui_right"]
			
		# Mostrar los sprites correspondientes al combo
		for accion in posibles_acciones:
			if ui_combo_nodos.has(accion):
				var sprite = ui_combo_nodos[accion]
				if accion in teclas_faltantes:
					sprite.show()
					sprite.frame = 0
				else:
					sprite.hide()
			
		puede_moverse = false
		combo_delay_timer = COMBO_INPUT_DELAY  # Iniciar el delay antes de detectar teclas
		if body.has_method("velocidad_reducida"):
			body.velocidad_reducida(true)
		
func procesar_combo():
	for accion in posibles_acciones:
		if Input.is_action_just_pressed(accion):
			if accion in teclas_faltantes:
				teclas_faltantes.erase(accion)
				# Cambiar al frame 1 cuando se presiona correctamente
				if ui_combo_nodos.has(accion):
					ui_combo_nodos[accion].frame = 1
			else:
				# Tecla incorrecta presionada durante el combo
				print("mal")
				emit_signal("combo")
				
	if teclas_faltantes.is_empty():
		# Combo completado exitosamente
		puede_moverse = true
		if camara_contro.has_method("opa_combo"):
			camara_contro.opa_combo()
		else:
			camara_contro.cinematica = false
		
		# Ocultar todos los sprites y volver al frame 0
		for accion in ui_combo_nodos:
			ui_combo_nodos[accion].hide()
			ui_combo_nodos[accion].frame = 0
		
		# Hacer que todos los mymbas del mismo yuyo vuelvan a su origen
		if mymba_en_combo != null and "id_yuyo_esperado" in mymba_en_combo:
			var grupo_yuyo = mymba_en_combo.id_yuyo_esperado
			for m in get_tree().get_nodes_in_group("mymba"):
				if m.get("id_yuyo_esperado") == grupo_yuyo:
					if m.has_method("volver_a_origen"):
						m.volver_a_origen()
		mymba_en_combo = null

func resetear_combo() -> void:
	mymba_en_combo = null
	teclas_faltantes.clear()
	combo_delay_timer = 0.0
	for accion in ui_combo_nodos:
		if ui_combo_nodos.has(accion) and ui_combo_nodos[accion] != null:
			ui_combo_nodos[accion].hide()
			ui_combo_nodos[accion].frame = 0
	puede_moverse = true
	if camara_contro != null:
		if camara_contro.has_method("opa_combo"):
			camara_contro.opa_combo()
		else:
			camara_contro.cinematica = false
