extends Node3D



var dialog_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  
var dialogos ={
	"Mami":[
		["Karãu","Mami, amosaingopáma ñande aokuéra.
(Mami, ya colgué toda la ropa)"],
		["Karãu Sy","¡Nde guapoíte ko che memby! ndereipe'ái ra'e nde fárra ao.
(¡Sos muy guapo mi hijo!, no te sacaste aún tu ropa de farra)"],
		["Karãu","Jeje, añemondeporãtama ¿Mba'éichapa reime?
(Jeje, voy a vestirme bien en seguida ¿Cómo te sentís?)"],
		["Karãu Sy", "Chekangy che mitã ha katu ag̃aite apu'ã jeýta.
(Estoy débil mi niño, pero en seguida me voy a levantar.)"],
		["Karãu", "Nanderasýpa mba'eve, ¿nandey'uhéipa?.
(No te duele pa nada, ¿no tenés sed?.)"],
		["Karãu Sy", "Che memby, ehomína eheka pohã ñana che pohãpe g̃uarã, ame'ẽta ndéve peteĩ kuatia'ipe la pohãnguéra.
(Mi hijo, anda por favor busca unos yuyos para mi remedio, Voy a darte una lista con los remedios.)"],
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
func _ready() -> void:
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	asigna_clave("Mami")
func _process(delta: float) -> void:
	$mama/AnimationPlayer.play("repira")
	if dialog_activo:
		
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()

func inic_dialog() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		return
	
	dialog_activo = true


	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])

func dialog_terminado() -> void:
	dialog_activo = false
	
func asigna_clave(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialog()
