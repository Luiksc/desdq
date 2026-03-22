extends Area3D
@export var nom_interac: String =""
@export var is_interaccion: bool= true

func _on_body_entered(body):
	if body is CharacterBody3D:
		print("tocao")
