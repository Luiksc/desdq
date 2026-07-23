extends Node3D

var cinematica :bool = false
var farra := false

@onready var camara=$Camera3D

@export var sensi := 0.004
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var minim_angulo_vertical = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var maxim_angulo_vertical = PI/4

var rotacion_guardada : Vector3
var mirando_atras : bool = false
@onready var mira_atras = $"../mira_atras"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
		if cinematica == false and not mirando_atras:
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
	
	
