extends Node3D

@onready var anima = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
var oho = false
func _ready() -> void:
	anima.play("repira")
	await anima.animation_finished
	anima.play("repira")
	await anima.animation_finished
	oho = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oho:
		anima.play("corre")
