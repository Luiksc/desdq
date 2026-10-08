extends Node

# ──────────────────────────────────────────────────────────────────────────────
# PausaManager – se agrega como hijo del nodo raíz del nivel (Node3D).
# Busca "Control/pausa" (o "Control/Pausa") y "Control/ã/AnimationPlayer".
# ──────────────────────────────────────────────────────────────────────────────

var label_pausa:     Label           = null
var anim_transicion: AnimationPlayer = null
var boton_flechita:  TextureButton   = null
var control_nodo:    Control         = null

var en_pausa:   bool = false
var procesando: bool = false


func _ready() -> void:
	# Procesar siempre, incluso cuando get_tree().paused == true
	process_mode = Node.PROCESS_MODE_ALWAYS

	# El padre es el Node3D del nivel; buscamos el hijo "Control"
	var padre = get_parent()
	if padre != null and padre.has_node("Control"):
		control_nodo = padre.get_node("Control") as Control

	if control_nodo == null:
		push_error("PausaManager: no se encontró 'Control' en el padre.")
		return

	# Label de pausa (acepta "pausa" o "Pausa")
	for nombre in ["pausa", "Pausa"]:
		if control_nodo.has_node(nombre):
			label_pausa = control_nodo.get_node(nombre) as Label
			break

	# AnimationPlayer del nodo de transición [ã]
	if control_nodo.has_node("ã/AnimationPlayer"):
		anim_transicion = control_nodo.get_node("ã/AnimationPlayer") as AnimationPlayer
		# Forzar ALWAYS para que pueda reproducir animaciones con el árbol pausado
		anim_transicion.process_mode = Node.PROCESS_MODE_ALWAYS

	if label_pausa != null:
		label_pausa.hide()
		_crear_boton_flechita()
	else:
		push_warning("PausaManager: label 'pausa'/'Pausa' no encontrado en Control.")


func _crear_boton_flechita() -> void:
	boton_flechita = TextureButton.new()
	boton_flechita.name                = "BotonVolverSeleccion"
	boton_flechita.process_mode        = Node.PROCESS_MODE_WHEN_PAUSED
	boton_flechita.texture_filter      = CanvasItem.TEXTURE_FILTER_NEAREST
	boton_flechita.texture_normal      = load("res://UI/fleclita.png")
	boton_flechita.ignore_texture_size = true
	boton_flechita.stretch_mode        = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	boton_flechita.custom_minimum_size = Vector2(64, 64)

	# Posicionar debajo del label de pausa usando sus mismos anchors
	boton_flechita.layout_mode    = 1
	boton_flechita.anchor_left    = label_pausa.anchor_left
	boton_flechita.anchor_right   = label_pausa.anchor_right
	boton_flechita.anchor_top     = label_pausa.anchor_bottom
	boton_flechita.anchor_bottom  = label_pausa.anchor_bottom + 0.08
	boton_flechita.offset_left    = 0.0
	boton_flechita.offset_right   = 0.0
	boton_flechita.offset_top     = 10.0
	boton_flechita.offset_bottom  = 10.0

	# Se agrega al Control (no al Label) para recibir input correctamente
	control_nodo.add_child(boton_flechita)
	boton_flechita.hide()

	boton_flechita.pressed.connect(_on_boton_flechita_pressed)


# ── Input ────────────────────────────────────────────────────────────────────
func _unhandled_input(event: InputEvent) -> void:
	if procesando:
		return

	# GDScript no admite \ para continuar líneas; se usa una variable auxiliar
	var es_tecla_escape := false
	if event is InputEventKey:
		var ev := event as InputEventKey
		if ev.pressed and not ev.echo and ev.keycode == KEY_ESCAPE:
			es_tecla_escape = true

	if event.is_action_pressed("ui_cancel") or es_tecla_escape:
		get_viewport().set_input_as_handled()
		_toggle_pausa()


# ── Alternar pausa ───────────────────────────────────────────────────────────
func _toggle_pausa() -> void:
	en_pausa = !en_pausa
	get_tree().paused = en_pausa

	if en_pausa:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		# "entrafa" baja la cortinilla cubriendo la pantalla
		if anim_transicion != null:
			anim_transicion.play("entrafa")
		if label_pausa != null:
			label_pausa.show()
		if boton_flechita != null:
			boton_flechita.show()
	else:
		if label_pausa != null:
			label_pausa.hide()
		if boton_flechita != null:
			boton_flechita.hide()
		# "salida" sube la cortinilla quitándola
		if anim_transicion != null:
			anim_transicion.play("salida")
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# ── Botón flechita: volver al menú de selección ──────────────────────────────
func _on_boton_flechita_pressed() -> void:
	if procesando:
		return
	procesando = true

	if label_pausa != null:
		label_pausa.hide()
	if boton_flechita != null:
		boton_flechita.hide()

	# Reanudar el árbol ANTES del await para que la animación pueda correr
	get_tree().paused = false

	if anim_transicion != null:
		anim_transicion.play("entrafa")
		await anim_transicion.animation_finished

	get_tree().change_scene_to_file("res://UI/menu_selccion.tscn")
