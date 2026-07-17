extends Node3D


@onready var posicion = $"posi_camara"
@onready var camara = $"Camera3D"
@onready var anima_dio =$Dionisi/AnimationPlayer
@onready var anima_marta =$Marta/AnimationPlayer
@onready var funcio =$funcionario


@onready var timer = $Timer
@onready var control_transi =$"Control/ã"
@onready var transi =$"Control/ã/AnimationPlayer"
@onready var carta=$Control/TextureRect/AnimationPlayer



var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"conversa":[
		["Dionisio","Marta, gracia a Dios ajoguáma ñande vakarã.
(Marta, Gracias a Dios ya compré una vaca)"],
		["Marta","hẽe, che agueru unos cuanto ta'ỹi ñañotỹ jeý hagua, yma guaréicha.
(Sii, yo traje unas semillas para plantar, como antes.)"],
],
	"Funcionario":[
		["Funcionario Municipal","e"],
		["Dionisio","Erumi ápe ne sombréro, che atermináta péa 
(Pasame tu sombrero, yo terminon por vos,)"],
	],
		
}

func _ready() -> void:
	transi.play("salida")
	await transi.animation_finished
	ini_dialogan("conversa")
	DialogSystem.dialogo_opa.connect(dialog_terminado)

	
	

func _process(delta: float) -> void:
	anima_dio.play("repira")
	anima_marta.play("repire")
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
		pass
	return
func ini_dialogan(id_npc: String) ->void:
	npc_actual = id_npc
	inic_dialo()
func llega():
	pass
