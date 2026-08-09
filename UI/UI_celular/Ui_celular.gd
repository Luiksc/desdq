extends CanvasLayer


var es_celular: bool = false
## true si hay un CharacterBody3D llamado "karau" o "jugador" en la escena.
## Cuando es false los botones táctiles se ocultan, pero el toque sigue
## llamando a neixt() para avanzar diálogos.
var hay_jugador: bool = false


func _ready() -> void:
	es_celular = OS.get_name() in ["Android", "iOS"] \
			or DisplayServer.is_touchscreen_available()

	# Esperar un frame para que todos los nodos de la escena estén listos
	await get_tree().process_frame
	_detectar_jugador()
	_actualizar_visibilidad_botones()

	if es_celular and hay_jugador:
		_activar_camara_tactil()


func _detectar_jugador() -> void:
	## Recorre todos los CharacterBody3D de la escena y comprueba su nombre.
	var nombres_jugador := ["karau", "jugador"]
	for nodo in get_tree().get_nodes_in_group(""):
		pass  # no usamos grupos aquí

	# Búsqueda directa por tipo y nombre en el árbol completo
	var todos := get_tree().root.find_children("*", "CharacterBody3D", true, false)
	for nodo in todos:
		if nodo.name.to_lower() in nombres_jugador:
			hay_jugador = true
			return
	hay_jugador = false


func _actualizar_visibilidad_botones() -> void:
	## Los botones solo son visibles si es celular Y hay jugador en escena.
	var mostrar_botones: bool = es_celular and hay_jugador
	for hijo in get_children():
		if hijo is TouchScreenButton:
			hijo.visible = mostrar_botones


func _activar_camara_tactil() -> void:
	var camaras = get_tree().get_nodes_in_group("camara_pivot")
	if camaras.size() > 0:
		camaras[0].activar_modo_tactil()
	else:
		push_warning("Ui_celular: No se encontró ningún nodo en el grupo 'camara_pivot'.")


func _process(_delta: float) -> void:
	# La lógica de ocultar/mostrar durante diálogo solo aplica
	# si hay jugador (y por tanto los botones son visibles).
	if not es_celular or not hay_jugador:
		return

	# Ocultar los botones táctiles mientras haya un diálogo en pantalla
	if DialogSystem.estar_mostrando():
		if visible:
			hide()
	else:
		if not visible:
			show()


func _input(event: InputEvent) -> void:
	# El avance de diálogo por toque funciona SIEMPRE en pantallas táctiles,
	# incluso cuando no hay jugador (escenas de solo diálogo).
	if not es_celular:
		return

	# Cualquier toque en la pantalla avanza el diálogo si hay uno activo
	if event is InputEventScreenTouch and event.pressed:
		if DialogSystem.estar_mostrando():
			DialogSystem.neixt()
			get_viewport().set_input_as_handled()
