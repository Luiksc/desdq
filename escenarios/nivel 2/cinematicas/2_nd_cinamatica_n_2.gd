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

var omaña = false
var moviendo_funcionario: bool = false
var vuelve_funcionario: bool = false


var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"conversa":[
		["Dionisio","Marta, Ndaikasovéima
(Marta,ya no hay caso.)"],
		["Marta","Ojupi meme pe alquiler.
(Siempre sube el alquiler)"],
		["Dionisio","Mba'éiko jajapóta
(Qué vamos a hacer)"]
],

	"Funcionario":[
		["Contratista","Buenos días che karai, ahendu'i la hendy kavaju resa, ¿ajépa?
(Buenos días señor, escuché que está dificil su situación, ¿no es así?)"],
		["Dionisio","Mba'éichapa, Añete upéva..
(Qué tal, es cierto...,)"],
		["Contratista","Che cheréra Antonio ha agueru peteĩ propuesta.
(Yo me llamo Antonio y traigo una propuesta de trabajo.)"],
		["Contratista","La ka'atýpe akóinte ñaikotevẽ ayuda.
(En los yerbales simpre necesitamos una ayuda.)"],
		["Contratista Antonio","Peguerekopaitéta pene rembi'urã
(Tendrán alimento pagado)"],
		["Contratista Antonio","tembiporukuéra
(Herramientas)"],
		["Contratista Antonio","pende rogarã
(Una casa.)"],
		["Contratista Antonio","Ha translado gratuito ka'atýpe.
(Y translado gratuito a los yerbales.)"],
		
	],
		
	"checkea" :[
		["Dionisio", "Marta, jahántema hese.
(Marta, iremos nomás ya.)"]
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
	

	anima_marta.play("repire")
	if omaña == false:
		anima_dio.play("repira")
	
	
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
		omaña = true
		$Dionisi/AnimationPlayer2.play("papel")
		await $Dionisi/AnimationPlayer2.animation_finished
		await get_tree().create_timer(3).timeout
		ini_dialogan("checkea")
	elif npc_actual == "checkea":
		transi.play("entrafa")
		await transi.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel 2/nivel_2.tscn")
	return
func ini_dialogan(id_npc: String) ->void:
	npc_actual = id_npc
	inic_dialo()
