extends Node3D

@onready var anima_don =$"don menu/AnimationPlayer"
@onready var desplazamiento=$"desplazamiento"
@onready var titulo = $Control/titulo/AnimationPlayer
@onready var anima_boton = $Control/Button/AnimationPlayer
@onready var boton = $Control/Button
@onready var anima_libro1 = $caso_mateo/AnimationPlayer
@onready var anima_libro2 = $caso_mensu/AnimationPlayer
@onready var anima_libro3 = $caso_karau/AnimationPlayer


@onready var transicion = $"Control/ã/AnimationPlayer"
@onready var anima_camara = $Camera3D/AnimationPlayer


var clicki1 = false
var clicki2 = false
var clicki3 = false
var oguapy = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desplazamiento.play("desplazamiento")
	await desplazamiento.animation_finished
	oguapy = true
	anima_don.play("oguapy")
	desplazamiento.play("se_sienta")
	await anima_don.animation_finished
	titulo.play("aparece")
	await titulo.animation_finished
	anima_boton.play("aparece")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oguapy == false:
		anima_don.play("oho")
	if clicki1:
		if Input.is_action_just_pressed("clicki"):
			clicki1=false
			anima_libro1.play("abre")
			await anima_libro1.animation_finished
			anima_camara.play("mateo_acerca")
			await anima_camara.animation_finished
			transicion.play("entrafa")
			await transicion.animation_finished
			get_tree().change_scene_to_file("res://escenarios/n_1_cinematica.tscn")
	if clicki2:
		if Input.is_action_just_pressed("clicki"):
			clicki2=false
			anima_libro2.play("abre")
			await anima_libro2.animation_finished
			anima_camara.play("mensu_acerca")
			await anima_camara.animation_finished
			transicion.play("entrafa")
			await transicion.animation_finished
			get_tree().change_scene_to_file("res://escenarios/nivel 2/cinematicas/1r_cinamatica_n_2.tscn")
	if clicki3:
		if Input.is_action_just_pressed("clicki"):
			clicki3=false
			anima_libro3.play("abre")
			await anima_libro3.animation_finished
			anima_camara.play("karau_acerca")
			await anima_camara.animation_finished
			transicion.play("entrafa")
			await transicion.animation_finished
			get_tree().change_scene_to_file("res://escenarios/nivel3/cinematucas/mama.tscn")
func _on_button_pressed() -> void:
	titulo.play("RESET")
	anima_boton.play("RESET")
	boton.hide()
	anima_camara.play("seleccion")
	


func _on_mateo_mouse_entered() -> void:
	anima_libro1.play("seleccion")
	await anima_libro1.animation_finished
	clicki1 = true
func _on_mateo_mouse_exited() -> void:
	anima_libro1.play("desseleccion")
	await anima_libro1.animation_finished
	clicki1 = false

func _on_mensu_mouse_entered() -> void:
	anima_libro2.play("seleccion")
	await  anima_libro2.animation_finished
	clicki2 = true
func _on_mensu_mouse_exited() -> void:
	anima_libro2.play("desselccion")
	await anima_libro2.animation_finished
	clicki2 = false
func _on_karau_mouse_entered() -> void:
	anima_libro3.play("seleccion")
	await  anima_libro3.animation_finished
	clicki3 = true
func _on_karau_mouse_exited() -> void:
	anima_libro3.play("desseleccion")
	await  anima_libro3.animation_finished
	clicki3 = false
