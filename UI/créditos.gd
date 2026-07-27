extends Node3D

@onready var anima_camara = $Camera3D/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	anima_camara.play_backwards("seleccion")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
