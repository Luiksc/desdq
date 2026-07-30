extends Node3D

@onready var piel_ini = $inicia
@onready var piel_jeroky = $ojeroky

@onready var anima_inicia = $inicia/AnimationPlayer
@onready var anima_jeroky=$ojeroky/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piel_jeroky.hide()
	
