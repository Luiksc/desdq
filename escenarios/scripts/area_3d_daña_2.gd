extends Area3D

var checkpoint_gestor: Node
var jugador: Node3D

signal jgd_omano

func _ready() -> void:
	var nivel := get_tree().current_scene
	if nivel != null:
		checkpoint_gestor = nivel.get_node_or_null("gestor_de_checkpoint")
		jugador = nivel.get_node_or_null("jugador")

	var nodo_actual := get_parent()
	while (checkpoint_gestor == null or jugador == null) and nodo_actual != null:
		if checkpoint_gestor == null:
			checkpoint_gestor = nodo_actual.get_node_or_null("gestor_de_checkpoint")
		if jugador == null:
			jugador = nodo_actual.get_node_or_null("jugador")
		nodo_actual = nodo_actual.get_parent()

	if checkpoint_gestor == null:
		push_error("No se encontro gestor_de_checkpoint desde %s" % get_path())
	if jugador == null:
		push_error("No se encontro jugador desde %s" % get_path())

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		emit_signal("jgd_omano")
		
