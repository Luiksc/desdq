extends Node3D


var npc_id: String = "iniciarf"

signal oñepyru(npc_id: String)




func _ready() -> void:
	oñepyru.emit(npc_id)
		
	
