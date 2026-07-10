extends Area3D

var checkpoint_gestor
var jugador

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_gestor= get_parent().get_node("gestor_de_checkpoint")
	jugador = get_parent().get_node("jugador")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





	
