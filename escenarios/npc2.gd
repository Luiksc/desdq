extends Area3D

@export var npc_id: String = "Mariano"

signal corpus_entro(npc_id: String)
signal corpus_salio(npc_id: String)

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon"):
		corpus_entro.emit(npc_id)
	


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugon"):
		corpus_salio.emit(npc_id)
	
	
