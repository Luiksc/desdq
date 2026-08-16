extends Node3D

var cinematica :bool = false
var farra := false

var modo_tactil: bool = false
var control_conectado: bool = false
@onready var camara = $Camera3D

@export var sensi := 0.004
@export var sensi_joystick := 1
@export var deadzone_joystick := 0.2
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var minim_angulo_vertical = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var maxim_angulo_vertical = PI/4

var rotacion_guardada : Vector3
var mirando_atras : bool = false
@onready var mira_atras = $"../mira_atras"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Fix Error 2: registrarse en el grupo para que Ui_celular.gd lo encuentre
	add_to_group("camara_pivot")
	# Fix Error 12: solo capturar mouse en PC, no en móvil
	var es_movil = OS.get_name() in ["Android", "iOS"] or DisplayServer.is_touchscreen_available()
	if not es_movil:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	control_conectado = Input.get_connected_joypads().size() > 0
	# Nos suscribimos para detectar conexión/desconexión en caliente
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
#func _process(delta: float) -> void:
#	if Input.is_action_pressed("clicki_derecho"):
#3		if not mirando_atras:
#			mirando_atras = true
#			camara.set_process(false)
#			rotacion_guardada = rotation
			
		# Posicionamos la cámara en el marker, y la orientamos igual que mira_atras
#		camara.global_transform = mira_atras.global_transform 
#	else:
#		if mirando_atras:
#			mirando_atras = false
#			camara.set_process(true)
#			rotation = rotacion_guardada


func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	control_conectado = Input.get_connected_joypads().size() > 0
	if connected:
		print("Mando conectado: ", Input.get_joy_name(device_id))
	else:
		print("Mando desconectado")


func activar_modo_tactil() -> void:
	modo_tactil = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:    #joy
	if cinematica or modo_tactil or not control_conectado:
		return
	_procesar_joystick_camara(delta)

func _procesar_joystick_camara(delta: float) -> void:
	var eje_x := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var eje_y := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(eje_x) < deadzone_joystick:
		eje_x = 0.0
	if abs(eje_y) < deadzone_joystick:
		eje_y = 0.0

	if eje_x == 0.0 and eje_y == 0.0:
		return

	rotation.y -= eje_x * sensi_joystick * delta
	rotation.y = wrapf(rotation.y, 0.0, TAU)
	rotation.x -= eje_y * sensi_joystick * delta
	rotation.x = clamp(rotation.x, minim_angulo_vertical, maxim_angulo_vertical)


func _unhandled_input(event: InputEvent) -> void:
		#if cinematica == false and not mirando_atras:
		#	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#		rotation.y -= event.relative.x * sensi
		#		rotation.y = wrapf(rotation.y, 0.0, TAU)
		#		rotation.x -= event.relative.y * sensi
		#		rotation.x = clamp(rotation.x, minim_angulo_vertical, maxim_angulo_vertical)


	# ── Modo celular ──
	if modo_tactil:
		if event is InputEventScreenDrag:
			
			rotation.y -= event.relative.x * sensi
			rotation.y = wrapf(rotation.y, 0.0, TAU)

			rotation.x -= event.relative.y * sensi
			rotation.x = clamp(rotation.x, minim_angulo_vertical, maxim_angulo_vertical)
		return 

	# ── Modo PC: mouse capturado ──
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * sensi
		rotation.y = wrapf(rotation.y, 0.0, TAU)

		rotation.x -= event.relative.y * sensi
		rotation.x = clamp(rotation.x, minim_angulo_vertical, maxim_angulo_vertical)
		if event.is_action_pressed("escape") or event.is_action_pressed("clicki"):
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
