extends CanvasLayer


var es_celular: bool = false


func _ready() -> void:
	es_celular = OS.get_name() in ["Android", "iOS"] \
				or DisplayServer.is_touchscreen_available()

	for hijo in get_children():
		if hijo is TouchScreenButton:
			hijo.visible = es_celular

	if es_celular:
		# Reintenta hasta 3 frames para que la cámara registre su grupo
		for _i in range(3):
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


# La acción "interaccion" en pantalla táctil es gestionada directamente
# por TouchScreenButton6. No se necesita inyección manual de InputEventAction.


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

	# Solo gestiona el avance de diálogo con toque en pantalla.
	# La acción "interaccion" fuera del diálogo es gestionada
	# directamente por TouchScreenButton6, sin inyección manual
	# (evita el doble disparo que generaba retraso e inconsistencias).
	if event is InputEventScreenTouch and event.pressed:
		if DialogSystem.estar_mostrando():
			DialogSystem.neixt()
			get_viewport().set_input_as_handled()
