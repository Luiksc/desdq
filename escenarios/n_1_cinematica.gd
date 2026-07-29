extends Node3D



@onready var transicion =$"Control/ã/AnimationPlayer"


@onready var ambiente = $chaco_ambiente
@onready var ambiente2= $pajaros_ambiente


var jugom_anima_actio = true
var jgd_omamo : bool = false
var mykure_velocidad: float = 10
var jugador_puede_interac: bool = false
var mykure_activu: bool = false
var finiquitable: bool = false

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  
var dialogos ={
	"Dialogo1":[
		["Delfina Servín","Mateo,¿ Moo piko nde reho jeýta?
(Mateo,¿Donde te vas a ir otra vez?)"],
		["Mateo Gamarra","Capataz orerenói jey kokuépe, ahamíta sapy'aite ha ajevpyta che kamba
(El capataz nos llamo de nuevo a la chacra, voy a irme un rato y vuelvo mi morena)"],
		["Delfina Servin","Che amosaingóta la aokuéra, roha'arota.
(Bueno,yo voy a colgar la ropa, te voy a espera)"],
		["Delfina Servín", "Animo'akena ahendu jey la rumor nde reimeha otro kuña ndive, chekueráima Mateo.
(Que no escuche ya otra vez ese rumor de que andás con otra mujer, me tenés harta Mateo.)"],
		["Mateo", "Umía vyrésa, agaite aju jeýta, chau.
Esas son tonterías, ya vuelvo, Chau."],
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


	transicion.play("salida")
	await transicion.animation_finished
	inicia_cine("Dialogo1")
	


	

	DialogSystem.dialogo_opa.connect(dialog_terminado)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if dialogo_activo:
		
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
		
func piensa_dialog(id: String) -> void:

	if pensamiento_activo:
		return  
	if not dialogos.has(id):
		return
	

	pensamiento_activo = true
	dialogo_activo = true
	for linea in dialogos[id]:
		DialogSystem.says(linea[1], linea[0])

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
	if npc_actual == "Dialogo1":
		$Control/Interac.hide()
		transicion.play("entrafa")
		
		await transicion.animation_finished
		get_tree().change_scene_to_file("res://escenarios/n_1.tscn")





func inicia_cine(id_del_npc: String) ->void:
	npc_actual = id_del_npc
	inic_dialo()

func mostrar_interac(id_del_npc: String) -> void:
	npc_actual = id_del_npc


# El jugador sale del área del NPC
func hide_interac(id_del_npc: String) -> void:
	if npc_actual == id_del_npc:
		npc_actual=""

	if dialogo_activo:
		dialogo_activo = false
