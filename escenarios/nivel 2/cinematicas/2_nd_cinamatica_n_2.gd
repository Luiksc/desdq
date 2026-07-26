extends Node3D


@onready var posicion = $"posi_camara"
@onready var camara = $"Camera3D"
@onready var anima_dio =$Dionisi/AnimationPlayer
@onready var anima_marta =$Marta/AnimationPlayer
@onready var funcio =$funcionario

@onready var data = $Control/Data/AnimationPlayer
@onready var timer = $Timer
@onready var control_transi =$"Control/ã"
@onready var transi =$"Control/ã/AnimationPlayer"
@onready var carta=$Control/TextureRect/AnimationPlayer

@onready var anima_funcio =$funcionario/blockbench_export/AnimationPlayer
@onready var marker_destino = $llega
@onready var marker_ida = $ida
@onready var timer_func=$Timer_funcionario

var moviendo_funcionario: bool = false
var vuelve_funcionario: bool = false


var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"conversa":[
		["Dionisio","Marta, Ndaikasovéima, hasy asýpe jahupyty la paga de alquiler
(Marta,ya no hay caso, muy dificilmente alcanzamos a pagar el alquiler.)"],
		["Marta","Che aikuave'ẽmbáma la ñande mueble péro, amáske los ára ohasa, hepyve la alquiler.
(Yo ya vendí todos nuestros muebles pero, con el pasar el tiempo cada vez es más caro el alquiler.)"],
		["Dionisio","Mba'éiko jajapóta
(Qué vamos a hacer)"]
],



	"Funcionario":[
		["Contratista","Buenos días cha karai, ahendu'i la hendy kavaju resa, ¿ajépa?
(Buenos días señor, escuché que está dificil su situacion, ¿no es así?)"],
		["Dionisio","Mba'éichapa, Añete upéva..
(Qué tal, es cierto...,)"],
		["Contratista","Che cheréra Antonio ha agueru peteĩ propuesta de trabajo ka'atýpe, pemba'apóta la ka'a jejapo.
(Yo me llamo Antonio y traigo una propuesta de trabajo en los yerbales, van a trabajar la fabricación de yerba mate.)"],
		["Marta","¿Ka'a jejapo?, ¿ha moõpa opyta upe mba'apoha?.
(¿Fabricación de yerba mate?,¿Y ese trabajo dónde es?)"],
		["Contratista Antonio","¡Naimombyrý hína! Oĩ peteĩ región pyahu, hérava Takuru puku, upépe romba'apo.
(¡No está lejos, Es en una nueva región llamada Tacurú pucú[Hernandarias] ahí trabajamos.)"],
		["Contratista Antonio","Oĩ translado gratis, peguerekótama pagado tembi'urã, tembiporukuéra, pende uniformerã ha lugar peikove hag̃ua.
(Tendrán traslado gratis, alimentos, herramienta, uniforme pagado y un lugar para vivir.)"],
		["Dionisio", "Marta, jahápy hese.
(Vamos por ello.)"]
	],
		
}

func _ready() -> void:
	transi.play("opyta")
	data.play("aparece")
	await data.animation_finished
	data.play("desaparece")
	await data.animation_finished
	transi.play("salida")
	await transi.animation_finished
	ini_dialogan("conversa")
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	

	
	

func _process(delta: float) -> void:
	anima_dio.play("repira")
	anima_marta.play("repire")

	
	
	if moviendo_funcionario and marker_destino:
		var distancia = funcio.global_position.distance_to(marker_destino.global_position)
		if distancia > 0.1:
			var direccion = (marker_destino.global_position - funcio.global_position).normalized()
			funcio.global_position += direccion * 7 * delta # Puedes ajustar la velocidad aquí
			if anima_funcio:
				anima_funcio.play("camina")
			
			var pos_objetivo = marker_destino.global_position
			pos_objetivo.y = funcio.global_position.y
			if funcio.global_position.distance_to(pos_objetivo) > 0.01:
				funcio.look_at(pos_objetivo, Vector3.UP)
		else:
			moviendo_funcionario = false
			if anima_funcio:
				anima_funcio.play("repira")
	else:
		if anima_funcio:
			anima_funcio.play("camina")

	if vuelve_funcionario and marker_ida:
		var distancia = funcio.global_position.distance_to(marker_ida.global_position)
		if distancia > 0.1:
			var direccion = (marker_ida.global_position - funcio.global_position).normalized()
			funcio.global_position += direccion * 7 * delta # Puedes ajustar la velocidad aquí
			if anima_funcio:
				anima_funcio.play("camina")
			
			var pos_objetivo = marker_ida.global_position
			pos_objetivo.y = funcio.global_position.y
			if funcio.global_position.distance_to(pos_objetivo) > 0.01:
				funcio.rotation.y= lerp_angle(funcio.rotation.y, (atan2(direccion.x, direccion.z))+ 3*PI/2,  .15)
		else:
			moviendo_funcionario = false
			if anima_funcio:
				anima_funcio.play("camina")
	else:
		if anima_funcio:
			anima_funcio.play("repira")
	

	
	
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()

func inic_dialo() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		return
	dialogo_activo = true
	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])

func dialog_terminado() -> void:
	dialogo_activo = false
	if npc_actual == "conversa":
		moviendo_funcionario = true
		timer_func.start()
		await timer_func.timeout
		moviendo_funcionario= false
		ini_dialogan("Funcionario")
		
	elif  npc_actual=="Funcionario":
		transi.play("entrafa")
		await transi.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel 2/nivel_2.tscn")
	return
func ini_dialogan(id_npc: String) ->void:
	npc_actual = id_npc
	inic_dialo()
