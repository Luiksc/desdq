extends Node3D


@onready var desplazamiento=$"desplazamiento"
@onready var titulo = $Control/titulo/AnimationPlayer
@onready var anima_boton = $Control/Button/AnimationPlayer
@onready var boton = $Control/Button
@onready var anima_libro1 = $caso_mateo/AnimationPlayer
@onready var anima_libro2 = $caso_mensu/AnimationPlayer
@onready var anima_libro3 = $caso_karau/AnimationPlayer


@onready var transicion = $"Control/ã/AnimationPlayer"
@onready var anima_camara = $Camera3D/AnimationPlayer
@onready var libro_mateo = $StaticBody3D
@onready var libro_mensu = $StaticBody3D2
@onready var libro_karau = $StaticBody3D3

var clicki1 = false
var clicki2 = false
var clicki3 = false
var oguapy = false
var procesando_click = false
var en_seleccion = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anima_camara.play("selenccionando")
	transicion.play("salida")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

			
	if procesando_click:
		return
		
	
		
	if clicki1 and Input.is_action_just_pressed("clicki"):
		_abrir_nivel(1)
	elif clicki2 and Input.is_action_just_pressed("clicki"):
		_abrir_nivel(2)
	elif clicki3 and Input.is_action_just_pressed("clicki"):
		_abrir_nivel(3)

func _abrir_nivel(nivel: int) -> void:
	procesando_click = true
	clicki1 = false
	clicki2 = false
	clicki3 = false
	match nivel:
		1:
			anima_libro1.play("abre")
			await anima_libro1.animation_finished
			anima_camara.play("mateo_acerca")
			await anima_camara.animation_finished
			transicion.play("entrafa")
			await transicion.animation_finished
			get_tree().change_scene_to_file("res://escenarios/n_1_cinematica.tscn")
		2:
			anima_libro2.play("abre")
			await anima_libro2.animation_finished
			anima_camara.play("mensu_acerca")
			await anima_camara.animation_finished
			transicion.play("entrafa")
			await transicion.animation_finished
			get_tree().change_scene_to_file("res://escenarios/nivel 2/cinematicas/1r_cinamatica_n_2.tscn")
		3:
			anima_libro3.play("abre")
			await anima_libro3.animation_finished
			anima_camara.play("karau_acerca")
			await anima_camara.animation_finished
			transicion.play("entrafa")
			await transicion.animation_finished
			get_tree().change_scene_to_file("res://escenarios/nivel3/cinematicas/mama.tscn")


func _on_button_pressed() -> void:
	en_seleccion = true
	titulo.play("RESET")
	anima_boton.play("RESET")
	boton.hide()
	anima_camara.play("seleccion")
	await anima_camara.animation_finished
	libro_mateo.input_ray_pickable = true
	libro_mensu.input_ray_pickable = true
	libro_karau.input_ray_pickable = true
	


func _on_mateo_mouse_entered() -> void:
	if procesando_click:
		return
	clicki1 = true
	anima_libro1.play("seleccion")

func _on_mateo_mouse_exited() -> void:
	if procesando_click:
		return
	clicki1 = false
	anima_libro1.play("desseleccion")

func _on_mensu_mouse_entered() -> void:
	if procesando_click:
		return
	clicki2 = true
	anima_libro2.play("seleccion")

func _on_mensu_mouse_exited() -> void:
	if procesando_click:
		return
	clicki2 = false
	anima_libro2.play("desseleccion")

func _on_karau_mouse_entered() -> void:
	if procesando_click:
		return
	clicki3 = true
	anima_libro3.play("seleccion")

func _on_karau_mouse_exited() -> void:
	if procesando_click:
		return
	clicki3 = false
	anima_libro3.play("desseleccion")
