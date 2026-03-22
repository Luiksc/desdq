extends Area3D


@onready var label =$Node3D/Camera3D/Label2


func _ready() -> void:
	label.hide()

	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon"):
		label.show()
func _on_body_exited(body: Node3D) -> void:

	if body.is_in_group("jugon"):
		label.hide() 
