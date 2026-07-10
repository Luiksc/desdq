extends Node3D

@onready var anima =$"ã/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anima.play("salida")
	await anima.animation_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
