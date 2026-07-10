extends Node3D

@export var npc_id: String ="despensa"
signal inicial(npc_id:String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inicial.emit(npc_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
