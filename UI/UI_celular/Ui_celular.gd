extends CanvasLayer


var es_celular: bool = false
var _procesando_touch: bool = false  # Guard para evitar recursión en parse_input_event


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
		
	if DialogSystem.estar_mostrando():
		if event is InputEventScreenTouch and event.pressed:
			DialogSystem.neixt()
			get_viewport().set_input_as_handled()
		return
		
	# Guard: evita que parse_input_event re-dispare _input() de forma recursiva
	if event is InputEventScreenTouch and not _procesando_touch:
		_procesando_touch = true
		var mouse_event = InputEventMouseButton.new()
		mouse_event.button_index = MOUSE_BUTTON_LEFT
		mouse_event.position = event.position
		mouse_event.global_position = event.position
		mouse_event.pressed = event.pressed
		Input.parse_input_event(mouse_event)
		_procesando_touch = false
