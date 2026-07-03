extends Area3D
var checkpoint_gestor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_gestor= get_parent().get_parent().get_node("gestor_de_checkpoint")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global"):
		checkpoint_gestor.ultima_posicion = $puntodeRespawn.global_position
