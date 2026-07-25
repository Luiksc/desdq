extends Control
@onready var anima_boton =  $Button/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anima_boton.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_button_pressed() -> void:
	OS.shell_open("https://miguelrafaelgimenez-ops.github.io/Relatos-Oculto/")




func _on_button_mouse_entered() -> void:
	anima_boton.play("seleccion")

func _on_button_mouse_exited() -> void:
	anima_boton.play("deseleccionado")
