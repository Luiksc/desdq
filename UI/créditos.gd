extends Node3D

@onready var transicion = $"ã/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transicion.play("RESET")
	$"don menu/AnimationPlayer".play("toca")
	await get_tree().create_timer(0.3).timeout
	$Camera3D2/AnimationPlayer.play("sealeja")
	await 	$Camera3D2/AnimationPlayer.animation_finished
	$Control/Label/AnimationPlayer.play("credita")
	await $Control/Label/AnimationPlayer.animation_finished
	transicion.play("entrafa")
	await transicion.animation_finished
	MusicaGlobal.detener_musica()
	get_tree().change_scene_to_file("res://UI/menu_cinema.tscn")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
