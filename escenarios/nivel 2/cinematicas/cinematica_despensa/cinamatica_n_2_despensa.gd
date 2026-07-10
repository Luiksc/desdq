extends Node3D

@onready var cine = $AnimationPlayer
@onready var dio =$blockbench_export3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cine.play("dio va")
	await cine.animation_finished
	dio.oho = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
