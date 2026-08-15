extends Node3D

var cinematica :bool = false
var farra := false
var combo := false
var modo_tactil: bool = false
var control_conectado: bool = false

@onready var camara=$Camera3D
@onready var punto_farra = $"../punto_cinema_farra"
@onready var punto_combo = $"../punto_combo"

@export var sensi := 0.004
@export var sensi_joystick := 1
@export var deadzone_joystick := 0.2
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var minim_angulo_vertical = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var maxim_angulo_vertical = PI/4

var original_spring_arm: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if camara and "spring_arm" in camara:
		original_spring_arm = camara.spring_arm
	control_conectado = Input.get_connected_joypads().size() > 0
	# Nos suscribimos para detectar conexión/desconexión en caliente
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if cinematica == false:
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotation.y -= event.relative.x * sensi
			rotation.y = wrapf(rotation.y, 0.0, TAU)
		
			rotation.x -= event.relative.y * sensi
			rotation.x = clamp(rotation.x, minim_angulo_vertical, maxim_angulo_vertical)

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

func posiciona():
	cinematica = true
	punto_farra.look_at(get_parent().global_position + Vector3(0, 1, 0), Vector3.UP)
	if camara and "spring_arm" in camara:
		camara.spring_arm = punto_farra
	cinematica = true
	
func posiciona_combo():
	cinematica = true
	
	# Al poner x=-4 y z=4, y hacer que mire al jugador, la rotación en el eje Y será exactamente -45 grados.
	punto_combo.position = Vector3(-4, 5, 4)
	punto_combo.look_at(get_parent().global_position + Vector3(0, 1, 0), Vector3.UP)
	
	if camara and "spring_arm" in camara:
		camara.spring_arm = punto_combo

func opa_combo():
	cinematica = false
	if camara and "spring_arm" in camara and original_spring_arm:
		camara.spring_arm = original_spring_arm
		#la funcion clamp hace que se limiten ciertos valores
	
 
func _on_combo_body_entered(body: Node3D) -> void:
	if body.is_in_group("mymba"):
		posiciona_combo()
	
