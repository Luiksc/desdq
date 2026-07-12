extends Control

@onready var transi = $"CanvasLayer/Control/ã/AnimationPlayer"
@onready var anjma = $Panel/AnimationPlayer

func _ready() -> void:
	transi.play("RESET")
	
func _process(delta: float) -> void:
	anjma.play("mueve")
func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_jugar_pressed() -> void:
	transi.play("entrafa")
	await transi.animation_finished
	get_tree().change_scene_to_file("res://escenarios/n_1.tscn")
