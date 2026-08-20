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
@onready var fondo_carta = $Control/final2
@onready var carta = $Control/final2/AnimationPlayer
@onready var anima_boton = $Control/final2/Button/AnimationPlayer
@onready var anima_qr = $Control/final2/Sprite2D/AnimationPlayer
@onready var info = $Control/informacion
@onready var e_siguiente = $Control/final2/siguiente
@onready var anima_e_siguiente = $Control/final2/siguiente/AnimatedSprite2D
var siguiente = false

func _ready() -> void:
	e_siguiente.hide()
	$Control/seguir.hide()
	fondo_carta.hide()
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
	$Karau.play()
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
	fondo_carta.show()
	await transicion.animation_finished
	carta.play("desliza")
	await carta.animation_finished
	anima_boton.play("aparicion")
	
	await anima_boton.animation_finished
	anima_qr.play("aparece")
	info.show()
	e_siguiente.show()
	$Control/seguir.show()
	
	siguiente = true
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anima_e_siguiente.play("new_animation")
	if siguiente:
		if Input.is_action_just_pressed("interaccion"):
			$"Control/ã/AnimationPlayer".play("entrafa")
			await $"Control/ã/AnimationPlayer".animation_finished
			get_tree().change_scene_to_file("res://UI/créditos.tscn")




func _on_button_2_pressed() -> void:
	$"Control/ã/AnimationPlayer".play("entrafa")
	await $"Control/ã/AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://UI/créditos.tscn")
