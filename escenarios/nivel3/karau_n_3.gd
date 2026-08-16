extends CharacterBody3D

signal combo
   
@onready var pivote: Node3D = $pivote
@onready var piel: Node3D = $karau
@onready var anima_karau : AnimationPlayer =  $karau/AnimationPlayer  # nodo de la cámara 
@onready var camara_contro = $pivote

@export var vel_rotacion: float  # qué tan rápido rota el personaje

var mymba_en_combo: Node3D = null
var teclas_faltantes: Array[String] = []
var posibles_acciones = ["ui_up", "ui_down", "ui_left", "ui_right", "interaccion", "saltar",
							"up", "down", "left", "right"]  # Las últimas 4 son alias táctiles
# Mapa de acción táctil → acción combo equivalente (para que el joystick virtual funcione)
var alias_tactil: Dictionary = {
	"up": "ui_up", "down": "ui_down", "left": "ui_left", "right": "ui_right"
}
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
var mouse_cam: bool= true 
var input_direccion := Vector3.ZERO

@export var tiem_jump_buffer: float = 0.15
@export var tiem_coyote: float = 0.15

const  LERP_VAL = .15
	

func _ready() -> void:

	fuerza_salto = (2 * distans_salto) / timp_salto
	gravedad = (-2 * distans_salto) / (timp_salto * timp_salto)
	anima_activo= true
	anima_karau.play("repira")
	
	
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

	
	if farra == false:
		input_direccion.x = Input.get_axis("left", "right")
		input_direccion.z = Input.get_axis("up", "down")
		input_direccion = input_direccion.normalized() 

	
	if is_on_floor():
		estuvo_suelo = true
		coyote_timer = tiem_coyote  
	elif estuvo_suelo:
		
		estuvo_suelo = false
	
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

	#  
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
		

		if "teclas_combo" in body:
			teclas_faltantes = body.teclas_combo.duplicate()
		else:
			teclas_faltantes = ["interaccion", "up", "right"]
			
	
		for accion in posibles_acciones:
			if ui_combo_nodos.has(accion):
				var sprite = ui_combo_nodos[accion]
				if accion in teclas_faltantes:
					sprite.show()
					sprite.frame = 0
				else:
					sprite.hide()
			
		puede_moverse = false
		combo_delay_timer = COMBO_INPUT_DELAY  
		if body.has_method("velocidad_reducida"):
			body.velocidad_reducida(true)
		
func procesar_combo():
	for accion in posibles_acciones:
		if Input.is_action_just_pressed(accion):
			# Traducir alias táctil a la acción combo que los mymbas esperan
			var accion_combo = alias_tactil.get(accion, accion)
			if accion_combo in teclas_faltantes:
				teclas_faltantes.erase(accion_combo)
				if ui_combo_nodos.has(accion_combo):
					ui_combo_nodos[accion_combo].frame = 1
			elif accion in teclas_faltantes:
				# Acción directa (sin alias) también válida
				teclas_faltantes.erase(accion)
				if ui_combo_nodos.has(accion):
					ui_combo_nodos[accion].frame = 1
			else:
				emit_signal("combo")
				if mymba_en_combo != null and "SPEED" in mymba_en_combo:
					$"../UndertaleDamageSoundEffect(mp3Cut_net)".play()
					mymba_en_combo.SPEED += 2
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
	# Restaurar velocidad original del mymba antes de limpiarlo
	if mymba_en_combo != null and mymba_en_combo.has_method("velocidad_reducida"):
		mymba_en_combo.velocidad_reducida(false)
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
