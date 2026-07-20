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

@onready var anima_funcio =$funcionario/AnimationPlayer
@onready var marker_destino = $llega
@onready var marker_ida = $ida
@onready var timer_func=$Timer_funcionario

var moviendo_funcionario: bool = false
var vuelve_funcionario: bool = false


var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"conversa":[
		["Dionisio","Marta, gracia a Dios ajoguáma ñande vakarã.
(Marta, Gracias a Dios ya compré una vaca)"],
		["Marta","hẽe, che agueru unos cuanto ta'ỹi ñañotỹ jey hag̃ua, yma guaréicha.
(Sii, yo traje unas semillas para plantar, como antes.)"],
],


	"Funcionario":[
		["Funcionario Municipal","Buenos dias señor, soy un funcionario municipal, he venido para avisarle que sus tierras han sido compradas por una empresa privada."],
		["Dionisio","Bueno dias che karia'y... 
(Buenos dias hijo...)"],
		["Dionisio","Chedisculpami, ndapillái mba'épa eréva nde..
(Discúlpeme, no entendí que decías.)"],
		["Funcionario","Karai Dionisio Báez, pende yvykuéra niko hína Estado mba'e, pee niko hína ocupantes, ndaha'éi penemba'e.
(Señor Dionisio Báez, sus tierras pertenecen al Estado, ustedes ahora son ocupantes, no son dueños.)"],
		["Dionisio","¡Anichéneti!, che rekove entéro aimeva'ekue ápe, che taita oñotỹva'ekue ko'ã yvy.
(¡No puede ser!, toda mi vida viví acá, mi abuelo cultivo estas tierras)"],
		["Funcionario","Ndaipóri kuatia he'íva ko'ã yvy penemba'e.
(No hay documentos que digan que estas tierras son suyas.)"],
		["Dionisio","Chéko Lopekue che karia'y, romanomba ñande yvy rodefendévo, Estado cherenói ha machéte che pópe asẽ ahuguaitĩ che pehẽguekuéra.
(Soy de la época de Solano López, nosotros morimos defenciendo nuestras tierrasn el Estado nos llamó y con machete en mano salí a encontrar a mis hermanos.)"],
		["Funcionario", "..."],
		["Funcionanrio","Ambyasy ne situación rehe.."],
		["Dionisio","MAERÃIKO ROHASA'AKUE KARUGUA HA TUJUKUA APYTÉPE..MAERÃIKO SI IPAHÁPE OJEIPE'APÁTA OREHEGUI LO ÚNICO ROGUEREKO GUETERI. 
(PARA QUÉ PASAMOS ENTRE PANTANOS Y BARRALES..PARA QUÉ SI AL FINAL NOS SACAN LO UNICO QUE TENEMOS AÚN.)"],
		["Funcionario","..."]
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
				anima_funcio.play("repira")
	else:
		if anima_funcio:
			anima_funcio.play("oho")

	if vuelve_funcionario and marker_ida:
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
			moviendo_funcionario = false
			if anima_funcio:
				anima_funcio.play("oho")
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
