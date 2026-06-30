extends Node3D

@onready var interac: Label = $Control/Label
@onready var npc = $npc/Area3D
@onready var jugador = $jugador  # referencia al nodo del jugador

var jugador_puede_interac: bool = false
var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"clotilde":[
		["Ña Clotilde","¡Que tal Ña Delfina! ¿le buscás a Mateo?"],
		["Ña Clotilde","Hayu una fiesta en la fábrica por el día de la Raza"],
		["Ña Clotilde","Ikatu Mateo ohora'e napépe."]
],
	"Mariano":[
		["Don Mariano", "Mba'eichapa Ña Servín"],
		["Don Mariano", "¿Mateo? Upe karia'y jeýma, le vi kuri yendose a la fiesta en la casa de Miguel Medina"],
		["Don Mariano", "Chéve guara, oho ojopo petei kuña ndive, ¡Ñandejára!"]
	],
	"npc3":[
		["Kalo'i","Hola Señora, Mateo se fue derecho ko tapére, allaitee en la casa de Don Medina"]
	]
}

func _ready() -> void:
	interac.hide()
	$npcs/npc_clotilde/Area3D.corpus_entro.connect(mostrar_interac)
	$npcs/npc_clotilde/Area3D.corpus_salio.connect(hide_interac)

	$"npcs/npc2-Mariano/Area3D".corpus_entro.connect(mostrar_interac)
	$"npcs/npc2-Mariano/Area3D".corpus_salio.connect(hide_interac) 
	
	$"npcs/kalo'i/Area3D".corpus_entro.connect(mostrar_interac)
	$"npcs/kalo'i/Area3D".corpus_salio.connect(hide_interac) 

	DialogSystem.dialogo_opa.connect(dialog_terminado)


func _process(delta: float) -> void:
	if dialogo_activo:
		# E funciona como "next" mientras el diálogo está ocurriendo
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			
	elif jugador_puede_interac:
		# E inicia el diálogo si el jugador está en el área y no hay diálogo activo
		if Input.is_action_just_pressed("interaccion"):
			inic_dialo()
			


func inic_dialo() -> void:
	if npc_actual=="":

		return
		
	if not dialogos.has(npc_actual):

		return
	
	dialogo_activo = true
	interac.hide()
	jugador.puede_moverse = false
	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])
	 # bloquea el movimiento del jugador
	#DialogSystem.says("¿No te enteraste de la fiesta que hizo la fábrica por el Día de la Raza ? Todos están ahí; seguramente Mateo también.", "Ña Clotilde")



# se llama mendiante señal cuando el dialogsystem termina todos los mensajes
func dialog_terminado() -> void:
	dialogo_activo = false
	jugador.puede_moverse = true  # desbloquea el movimiento
	# Si el jugador todavía está en el área, volvemos a mostrar el label de interacción
	if jugador_puede_interac:
		interac.show()


# El jugador entra al área del NPC
func mostrar_interac(id_del_npc: String) -> void:
	interac.show()
	jugador_puede_interac = true
	npc_actual = id_del_npc


# El jugador sale del área del NPC
func hide_interac(id_del_npc: String) -> void:
	if npc_actual == id_del_npc:
		interac.hide()
		jugador_puede_interac = false
		npc_actual=""
	# Si se va mientras hay un diálogo activo, reseteamos y desbloqueamos
	if dialogo_activo:
		dialogo_activo = false
		jugador.puede_moverse = true
