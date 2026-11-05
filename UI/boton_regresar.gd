extends Button
@onready var boton = preload("res://UI/volver_boton.png")
@onready var presionado = preload("res://UI/volver_boton_presionado.png")
@onready var buton = $boton_regresar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_mouse_entered() -> void:
	buton.texture = presionado


func _on_mouse_exited() -> void:
	buton.texture = boton


func _on_pressed() -> void:
	
	get_tree().change_scene_to_file("res://UI/menu_cinema.tscn")
