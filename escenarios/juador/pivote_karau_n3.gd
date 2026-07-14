extends Node3D

var cinematica :bool = false
var farra := false
var combo := false

@onready var camara=$Camera3D
@onready var punto_farra = $"../punto_cinema_farra"
@onready var punto_combo = $"../punto_combo"

@export var sensi := 0.004
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var minim_angulo_vertical = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var maxim_angulo_vertical = PI/4

var original_spring_arm: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if camara and "spring_arm" in camara:
		original_spring_arm = camara.spring_arm


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if cinematica == false:
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
	punto_farra = punto_farra.position
	punto_farra.look_at(get_parent().global_position + Vector3(0, 1, 0), Vector3.UP)
	if camara and "spring_arm" in camara:
		camara.spring_arm = punto_farra
	
func posiciona_combo():
	cinematica = true
	
	# Ajustamos la posición relativa del punto_combo para que esté arriba y a la izquierda.
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
	
