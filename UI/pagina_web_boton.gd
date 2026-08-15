extends Button

@onready var textura_presionad = preload("res://UI/web_boton_pressd.png")
@onready var textura = preload("res://UI/web_boton.png")
@onready var boton = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_mouse_entered() -> void:
	boton.texture = textura_presionad

func _on_mouse_exited() -> void:
	boton.texture = textura
