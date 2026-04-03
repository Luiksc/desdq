extends Area3D

signal corpus_entro
signal corpus_salio



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon"):
		corpus_entro.emit()
	
 # Replace with function body.

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugon"):
		corpus_salio.emit()
