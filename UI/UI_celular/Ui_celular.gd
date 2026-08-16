extends CanvasLayer


var es_celular: bool = false


func _ready() -> void:
	es_celular = OS.get_name() in ["Android", "iOS"] \
				or DisplayServer.is_touchscreen_available()

	for hijo in get_children():
		if hijo is TouchScreenButton:
			hijo.visible = es_celular

	if es_celular:
		# Fix Error 1: reintenta hasta 10 frames para que la cámara registre su grupo
		for _i in range(10):
			await get_tree().process_frame
			if get_tree().get_nodes_in_group("camara_pivot").size() > 0:
				break
		_activar_camara_tactil()


func _activar_camara_tactil() -> void:
	var camaras = get_tree().get_nodes_in_group("camara_pivot")
	if camaras.size() > 0:
		camaras[0].activar_modo_tactil()
	else:
		push_warning("Ui_celular: No se encontró ningún nodo en el grupo 'camara_pivot'.")


# Fix Error 11: detecta también el AnimatedSprite2D "interaccion2" del DialogSystem
func _label_continuar_visible() -> bool:
	var sprite = DialogSystem.get_node_or_null("interaccion2")
	if sprite and sprite.visible:
		return true
	var escena = get_tree().current_scene
	if not is_instance_valid(escena):
		return false
	for nodo in escena.find_children("*", "Label", true, false):
		if nodo is Label and nodo.visible and "[E] para continuar" in nodo.text:
			return true
	return false


# Fix Error 4: oculta/muestra solo los TouchScreenButton hijos, no el CanvasLayer entero
func _set_botones_visibles(valor: bool) -> void:
	for hijo in get_children():
		if hijo is TouchScreenButton:
			hijo.visible = valor


func _process(_delta: float) -> void:
	if not es_celular:
		return

	if DialogSystem.estar_mostrando():
		_set_botones_visibles(false)
	else:
		_set_botones_visibles(true)


func _input(event: InputEvent) -> void:
	if not es_celular:
		return

	if event is InputEventScreenTouch and event.pressed:
		if DialogSystem.estar_mostrando():
			DialogSystem.neixt()
			get_viewport().set_input_as_handled()
		elif _label_continuar_visible():
			var accion := InputEventAction.new()
			accion.action = "interaccion"
			accion.pressed = true
			# Fix Error 5: set_input_as_handled antes de parse_input_event
			get_viewport().set_input_as_handled()
			Input.parse_input_event(accion)
