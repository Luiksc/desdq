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
		["Delfina Servín","Mateo,¿Moõw piko nde reho jeýta?
(Mateo,¿Donde te vas a ir otra vez?)"],
		["Mateo Gamarra","Aháta sapy'aite kokuére ha ajevýta
(Me voy una la chacra, voy a irme un rato y vuelvo )"],
		["Delfina Servin","Che amosaingóta la aokuéra, animo'ake epyta tape ykére.
(Bueno,yo voy a colgar la ropa, no te vayas que a quedar por el camino.)"],
		["Mateo", "A sus órdenes, he'i sepulcrero ipióla pyahu.
(A sus ordenes, dice el sepulcrero con cuerda nueva.)"]
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
