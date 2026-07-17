extends Node3D

@onready var anima = $AnimationPlayer
@onready var dialogost = $"../DialogSystem"
# Called when the node enters the scene tree for the first time.
var oho = false
func _process(delta: float) -> void:
	if oho:
		anima.play("corre")
	else:
		anima.play("repira")
