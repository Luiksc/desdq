extends Node3D
@onready var transicion = $"Control/ã/AnimationPlayer"

@onready var anima_ini = $"npcs/Mateo ha emilia/Mateo a emilia/inicia/AnimationPlayer"
@onready var anima_jeroky = $"npcs/Mateo ha emilia/Mateo a emilia/ojeroky/AnimationPlayer"
@onready var piel_ini = $"npcs/Mateo ha emilia/Mateo a emilia/inicia"
@onready var piel_jeroky = $"npcs/Mateo ha emilia/Mateo a emilia/ojeroky"

@onready var anima_delfi = $delfina/AnimationPlayer
var ojeroky = false


var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  
var dialogos ={
	"Dialogo1":[
		["Ña Florida","Che ha'evoi niko ndéve Delfina
(Te dije luego Delfina.)"],
		["Delfina Servín","MATEO,¿MBA'ÉIKO NDE EJAPO ÁPE, ANIVÉNA PÉICHA REIKO?
(MATEO,¿QUE HACES ACÁ, NO HAGAS ESTAS COSAS?)"],
		["Mateo", "Ndaikáso, Si es que ejedicustárõ che apoíntene ndehegui.
(No hay caso, si no te gusta te voy a dejar.)"],
		["Delfina", "CHE HA'E DELFINA SERVÍN
(YO SOY DELFINA SERVÍN)"],
		["Delfina", "NE'ĨRA CHEIKUAAPA, KUÑA JEPE NIKO CHE, ANICHEVA'ERÃ CHEBURLA
(AÚN NO ME CONOCES, AUNQUE SEA MUJER, NO TE BURLES DE MÍ)"],
	],
	"Mariano":[
		["Don Mariano", "Mba'éichapa Ña Servín
(Cómo está Doña Servín)"],
		["Don Mariano", "¿Mateo? Upe karia'y jeýma, le vi kuri yendose a la fiesta en la casa de Miguel Medina
(¿Mateo? ese muchacho ya otra vez, se estaba yendo a la fiesta en la casa de Miguel Madina)"],
		["Don Mariano", "Chéve g̃uarã, oho ojopo Emilia Ortiz ndive, ¡Ñandejára!
(Para mí que se iba agarrado de la mano con Emilia Ortiz, ¡Dios mío!)"]
	]
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	piel_jeroky.hide()
	transicion.play("salida")
	await transicion.animation_finished
	ini_dialog("Dialogo1")
	anima_ini.play("bailan")
	await anima_ini.animation_finished
	piel_ini.hide()
	piel_jeroky.show()
	ojeroky =true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anima_delfi.play("oha'aro")
	if ojeroky:
		anima_jeroky.play("bailan")
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
	
func ini_dialog(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
