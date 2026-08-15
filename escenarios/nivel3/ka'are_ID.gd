extends Node3D

## Identificador único de este objeto (ej: "ka'arurupa", "ka'are", "amba'y")
@export var id_objeto: String = "ka'aré"

# Señal que se envía al script de nivel_3 cuando el jugador entra al área
signal jugador_entro(id: String)

func _ready() -> void:
	# Conectar el Area3D de este objeto
	var area = get_node_or_null("MeshInstance3D/Area3D")
	if area == null:
		area = get_node_or_null("Area3D")
	if area:
		area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global"):
		
		emit_signal("jugador_entro", id_objeto)
		
		hide()
		# Desconectar para que no se dispare de nuevo
		var area = get_node_or_null("MeshInstance3D/Area3D")
		if area == null:
			area = get_node_or_null("Area3D")
		if area:
			area.body_entered.disconnect(_on_area_body_entered)
