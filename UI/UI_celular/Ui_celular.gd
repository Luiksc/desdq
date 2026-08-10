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
