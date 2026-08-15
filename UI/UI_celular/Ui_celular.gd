extends CanvasLayer


var es_celular: bool = false


func _ready() -> void:
	es_celular = OS.get_name() in ["Android", "iOS"] \
				or DisplayServer.is_touchscreen_available()

	for hijo in get_children():
		if hijo is TouchScreenButton:
			hijo.visible = es_celular

	if es_celular:
		await get_tree().process_frame
		_activar_camara_tactil()


func _activar_camara_tactil() -> void:
	var camaras = get_tree().get_nodes_in_group("camara_pivot")
	if camaras.size() > 0:
		camaras[0].activar_modo_tactil()
	else:
		push_warning("Ui_celular: No se encontró ningún nodo en el grupo 'camara_pivot'.")


func _label_continuar_visible() -> bool:
	var escena = get_tree().current_scene
	if not is_instance_valid(escena):
		return false
	for nodo in escena.find_children("*", "Label", true, false):
		if nodo is Label and nodo.visible and "[E] para continuar" in nodo.text:
			return true
	return false


func _process(_delta: float) -> void:
	if not es_celular:
		return

	if DialogSystem.estar_mostrando():
		if visible:
			hide()
	else:
		if not visible:
			show()


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
			Input.parse_input_event(accion)
			get_viewport().set_input_as_handled()
