extends Node3D

@export var npc_id: String = "pensamiento"
var ohota = false

signal piensa(npc_id: String)





#if body.is_in_group("jugon"):
#	piensa.emit(npc_id)
		
	




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_trigger_farra_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") and ohota:
		piensa.emit(npc_id)
