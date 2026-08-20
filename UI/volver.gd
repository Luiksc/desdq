extends Button
@onready var textura_presionad = preload("res://UI/volver_boton_presionado.png")
@onready var textura = preload("res://UI/volver_boton.png")
@onready var boton = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_mouse_entered() -> void:
		boton.texture = textura_presionad


func _on_mouse_exited() -> void:
	boton.texture = textura
