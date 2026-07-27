
extends Button
@onready var textura_presionad = preload("res://UI/iniciar_boton_presionado.png")
@onready var textura = preload("res://UI/iniciar_botonm.png")
@onready var boton = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	boton.texture = textura_presionad


func _on_mouse_exited() -> void:
	boton.texture = textura
