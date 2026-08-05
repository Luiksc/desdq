extends Node3D


@onready var posicion = $"posi_camara"
@onready var posicion2 = $posi_camara2
@onready var camara = $"Camera3D"
@onready var anima_dio =$Dionisi/base/AnimationPlayer
@onready var anima_dio_kunuu =$Dionisi/base/kunuu
@onready var anima_marta =$Marta/AnimationPlayer
@onready var anima_marta_plantas =$Marta/plantea

@onready var funcio =$funcionario
@onready var dionisio = $Dionisi
@onready var marta = $Marta

@onready var data = $Control/Data/AnimationPlayer
@onready var timer = $Timer
@onready var control_transi =$"Control/ã"
@onready var transi =$"Control/ã/AnimationPlayer"
@onready var carta=$Control/TextureRect/AnimationPlayer

@onready var anima_funcio =$funcionario/AnimationPlayer
@onready var marker_destino = $llega
@onready var marker_ida = $ida
@onready var timer_func=$Timer_funcionario
@onready var papel = $kuatias

var moviendo_funcionario: bool = false
var vuelve_funcionario: bool = false


var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"conversa":[
		["Marta","Hasy peve, ñañepyru jey.
(Al fin, comenzamos de nuevo)"],
		
],


	"Funcionario":[
		["Funcionario Municipal","Buenos dias señor, soy un funcionario público."], #, he venido para avisarle que sus tierras han sido compradas por una empresa privada.
		["Dionisio","Mba'eichapa nde ko'ẽ chera'y.
(Buenos dias hijo)"],
		["Funcionario","Agueru ndéve petei notificación municipalidad guive.
(Le traigo una notificación de la municipalidad."],
		["Funcionario","Ko'a yvy ndaha'evéima nemba'e"]
	],

	"funcionario2":[
		["Dionisio","MBA'ERE PIKO?"],
		["Funcionanrio","Petei empresa ogueru ko kuatia"],
		["Funcionario","Ambyasy  ne situacion rehe..."]
	],
	"ipochy":[
		["Dionisio","MAERÃIKO ROHASA'AKUE KARUGUA HA TUJUKUA APYTÉPE..MAERÃIKO SI IPAHÁPE OJEIPE'APÁTA OREHEGUI LO ÚNICO ROGUEREKO GUETERI. 
(PARA QUÉ PASAMOS ENTRE PANTANOS Y BARRALES..PARA QUÉ SI AL FINAL NOS SACAN LO UNICO QUE TENEMOS AÚN.)"],
		["Funcionario","..."]
	]
		
}

func _ready() -> void:
	$Dionisi/blockbench_export.hide()
	papel.hide()
	funcio.global_position = marker_ida.global_position
	
	transi.play("opyta")
	data.play("aparece")
	await data.animation_finished
	data.play("desaparece")
	await data.animation_finished
	anima_dio_kunuu.play("kunu'u")
	anima_marta_plantas.play("plantea")
	transi.play("salida")
	await transi.animation_finished
	await get_tree().create_timer(6).timeout
	transi.play("entrafa")
	await transi.animation_finished
	dionisio.global_position = $posi_dionisio.global_position
	marta.position = $posi_marta.position
	marta.rotate_y(-34.9)
	dionisio.rotate_y(-65.5)
	anima_dio_kunuu.stop()
	anima_marta_plantas.stop()
	var anim_dio = anima_dio.get_animation("repira")
	var anim_mar = anima_marta.get_animation("repire")
	anim_mar.loop_mode = Animation.LOOP_LINEAR
	anim_dio.loop_mode = Animation.LOOP_LINEAR
	anima_dio.play("repira")
	anima_marta.play("repire")
	print("yawe")
	camara.global_position = $inicial_posi2.global_position
	transi.play("salida")
	
	ini_dialogan("conversa")
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	

	
	

func _process(delta: float) -> void:

	$vaka/AnimationPlayer.play("achuses")
	
	
	if moviendo_funcionario and marker_destino:
		var distancia = funcio.global_position.distance_to(marker_destino.global_position)
		if distancia > 0.1:
			var direccion = (marker_destino.global_position - funcio.global_position).normalized()
			funcio.global_position += direccion * 7 * delta # Puedes ajustar la velocidad aquí
			if anima_funcio:
				anima_funcio.play("oho")
			
			var pos_objetivo = marker_destino.global_position
			pos_objetivo.y = funcio.global_position.y
			if funcio.global_position.distance_to(pos_objetivo) > 0.01:
				funcio.look_at(pos_objetivo, Vector3.UP)
		else:
			moviendo_funcionario = false
			if anima_funcio:
				papel.show()
				

	elif vuelve_funcionario and marker_ida:
		var distancia = funcio.global_position.distance_to(marker_ida.global_position)
		if distancia > 0.1:
			var direccion = (marker_ida.global_position - funcio.global_position).normalized()
			funcio.global_position += direccion * 7 * delta # Puedes ajustar la velocidad aquí
			if anima_funcio:
				anima_funcio.play("oho")
			
			var pos_objetivo = marker_ida.global_position
			pos_objetivo.y = funcio.global_position.y
			if funcio.global_position.distance_to(pos_objetivo) > 0.01:
				funcio.rotation.y= lerp_angle(funcio.rotation.y, (atan2(direccion.x, direccion.z))+ 3*PI/2,  .15)
		else:
			vuelve_funcionario = false
			if anima_funcio:
				anima_funcio.play("repira")
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
		$funcionario/AnimationPlayer2.play("papel")
		await $funcionario/AnimationPlayer2.animation_finished
		$funcionario/AnimationPlayer2.play("repira_papel")
	
	elif npc_actual == "Funcionario":
		$Dionisi/base.hide()
		$Dionisi/blockbench_export.show()
		ini_dialogan("funcionario2")
		
	elif  npc_actual=="ipochy":
		camara.position = $inicial_posi.position
		vuelve_funcionario=true
		timer_func.start()
		await timer_func.timeout
		transi.play("entrafa")
		await transi.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel 2/cinematicas/2nd_cinamatica_n_2.tscn")
	return
func ini_dialogan(id_npc: String) ->void:
	npc_actual = id_npc
	inic_dialo()
