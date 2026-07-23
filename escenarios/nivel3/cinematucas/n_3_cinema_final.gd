extends Node3D

@onready var karau_ave = $guyralio
@onready var anima_ave = $guyralio/AnimationPlayer
@onready var karau = $karau
@onready var anima_karau = $karau/AnimationPlayer
@onready var transicion = $Control/fade/ColorRect/AnimationPlayer
@onready var anima_camara = $Camera3D/AnimationPlayer
@onready var ave_karau_vuela = $vuela
@onready var anima_vuelo_ave = $vuela/AnimationPlayer
@onready var ruta_vuelo = $vuela/desplazaminetoi
@onready var carta = $Control/TextureRect/AnimationPlayer
@onready var info = $Control/informacion

func _ready() -> void:
	info.hide()
	carta.play("RESET")
	karau_ave.hide()
	ave_karau_vuela.hide()
	transicion.play("desaparece")
	await transicion.animation_finished
	anima_camara.play("movimiento")
	await anima_camara.animation_finished
	
	karau.hide()
	karau_ave.show()
	anima_camara.play("se aleja")
	await anima_camara.animation_finished
	anima_ave.play("oñeme'e en cuenta")
	await anima_ave.animation_finished
	await get_tree().create_timer(3.0).timeout
	anima_camara.play("enfoca_vuelo")
	await anima_camara.animation_finished
	karau_ave.hide()
	ave_karau_vuela.show()
	anima_vuelo_ave.play("vuela")
	ruta_vuelo.play("movimiento")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(3.0).timeout
	transicion.play("aparece")
	carta.play("aparece")
	info.show()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
