extends Sprite3D

# Hace que el sprite siempre mire de frente a la cámara (efecto billboard manual).
# Esto es equivalente a Billboard = Enabled, pero mediante código
# para tener control total si se necesita ajustar en el futuro.

@onready var camara: Camera3D = get_viewport().get_camera_3d()

func _process(_delta: float) -> void:
	if camara == null:
		camara = get_viewport().get_camera_3d()
		return

	# Apunta el sprite hacia la posición de la cámara
	look_at(camara.global_position, Vector3.UP)
