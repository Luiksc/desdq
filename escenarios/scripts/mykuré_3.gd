extends CharacterBody3D

var jugador: Node3D
var triger_mykure: Area3D
var puede_espantar: bool = false
var SPEED: float = 25
  
@onready var sape = $"../../Sápe"
@onready var atake_sond = $SonidoMykure
@export var inicio: Marker3D
@export var punto_retiro: Marker3D

enum estado {
	esperando,
	persiguiendo,
	retirada
}

var Estado = estado.esperando


func _ready() -> void:
	show()
	buscar_referencias()


func _physics_process(_delta: float) -> void:
	match Estado:
		estado.esperando:
			velocity = Vector3.ZERO

		estado.persiguiendo:
			if jugador == null:
				velocity = Vector3.ZERO
				return
			
			var direccion = jugador.global_position - global_position
			
			direccion = direccion.normalized()
			velocity = direccion * SPEED
			move_and_slide()

		estado.retirada:
			if punto_retiro == null:
				velocity = Vector3.ZERO
				return

			var direccion = punto_retiro.global_position - global_position
			direccion.y = 0
			direccion = direccion.normalized()
			velocity = direccion * SPEED
			move_and_slide()

			if global_position.distance_to(punto_retiro.global_position) < 0.5:
				hide()

	if Input.is_action_just_pressed("interaccion") and puede_espantar:
		sape.play()
		detenido_sape()
		puede_espantar=false


func buscar_referencias() -> void:
	var nivel := get_tree().current_scene
	if nivel != null:
		jugador = nivel.get_node_or_null("jugador")
		triger_mykure = buscar_trigger_en(nivel)

	var nodo_actual := get_parent()
	while (jugador == null or triger_mykure == null) and nodo_actual != null:
		if jugador == null:
			jugador = nodo_actual.get_node_or_null("jugador")
		if triger_mykure == null:
			triger_mykure = buscar_trigger_en(nodo_actual)
		nodo_actual = nodo_actual.get_parent()

	if jugador == null:
		push_error("No se encontro jugador desde %s" % get_path())
	if triger_mykure == null:
		push_error("No se encontro el trigger de mykure desde %s" % get_path())


func buscar_trigger_en(nodo: Node) -> Area3D:
	var triggers := nodo.get_node_or_null("triggers")
	if triggers == null:
		return null

	var nombre_trigger := "Mykure_trigger" + obtener_numero_de_mykure()
	return triggers.get_node_or_null(nombre_trigger) as Area3D


func obtener_numero_de_mykure() -> String:
	var numero := ""
	for letra in String(name):
		if letra >= "0" and letra <= "9":
			numero += letra
	return numero


func activar_persecucion(body: Node3D) -> void:
	if es_jugador(body):
		atake_sond.play()
		puede_espantar = true
		Estado = estado.persiguiendo


func es_jugador(body: Node3D) -> bool:
	return body.is_in_group("jugon") or body.is_in_group("jugador_global")


func detenido_sape() -> void:
	Estado = estado.retirada
	if is_instance_valid(triger_mykure):
		triger_mykure.queue_free()
		triger_mykure = null
		hide()


func reinicio() -> void:
	Estado = estado.esperando
	velocity = Vector3.ZERO
	if inicio != null:
		global_position = inicio.global_position
	show()
	puede_espantar = false



func _on_mykure_trigger_3_body_entered(body: Node3D) -> void:
	
	activar_persecucion(body)



func _on_area_3d_daña_3_body_entered(body: Node3D) -> void:
	if es_jugador(body):
		reinicio()
