extends Node3D

var cinematica: bool = false
var farra := false

# true cuando el juego corre en celular — activado por Ui_celular.gd
var modo_tactil: bool = false

@onready var camara = $Camera3D

@export var sensi := 0.004
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var minim_angulo_vertical = -PI / 2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var maxim_angulo_vertical = PI / 4


func _ready() -> void:
	# Registrarse en el grupo para que Ui_celular.gd lo encuentre
	add_to_group("camara_pivot")
	# En PC captura el mouse normalmente
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Llamado por Ui_celular.gd cuando detecta que es celular
func activar_modo_tactil() -> void:
	modo_tactil = true
	# Soltar el mouse para que no interfiera con la pantalla táctil
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	if cinematica:
		return

	# ── Modo CELULAR: arrastre táctil ──────────────────────────────
	if modo_tactil:
		if event is InputEventScreenDrag:
			# Arrastrar derecha → cámara rota a la derecha (dirección intuitiva)
			rotation.y -= event.relative.x * sensi
			rotation.y = wrapf(rotation.y, 0.0, TAU)

			rotation.x -= event.relative.y * sensi
			rotation.x = clamp(rotation.x, minim_angulo_vertical, maxim_angulo_vertical)
		return  # En celular ignorar el resto (mouse, escape, etc.)

	# ── Modo PC: mouse capturado ───────────────────────────────────
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


# la funcion clamp hace que se limiten ciertos valores
# func mueve_camara():
