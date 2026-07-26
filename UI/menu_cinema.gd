extends Node3D

@onready var anima_don =$"don menu/AnimationPlayer"
@onready var desplazamiento=$"desplazamiento"
var oguapy = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desplazamiento.play("desplazamiento")
	await desplazamiento.animation_finished
	oguapy = true
	anima_don.play("oguapy")
	desplazamiento.play("se_sienta")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oguapy == false:
		anima_don.play("oho")
