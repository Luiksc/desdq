extends Node3D

@onready var interac: Label = $Control/Interactuar
@onready var espantad: Label = $Control/espantar
@onready var jugador = $jugador  # referencia al nodo del jugador
@onready var mykure = $"enemigos/mykure"
@onready var pensamiento=$triggers/triger_delfi
@onready var anima_transi_sali = $transicio/AnimationPlayer


var mykure_velocidad: float = 10
var jugador_puede_interac: bool = false
var mykure_activu: bool = false
var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo
var dialogos ={
	"florida":[
		["Ña florida","¡Qué tal Ña Delfina! ¿le buscás a Mateo?"],
		["Ña florida","Hay una fiesta en la fábrica por el día de la Raza"],
		["Ña florida","Ikatu Mateo ohora'e napépe.
(seguro se fue allá)"]
],
	"Mariano":[
		["Don Mariano", "Mba'éichapa Ña Servín
(Cómo está Doña Servín)"],
		["Don Mariano", "¿Mateo? Upe karia'y jeýma, le vi kuri yendose a la fiesta en la casa de Miguel Medina
(¿Mateo? ese muchacho ya otra vez, se estaba yendo a la fiesta en la casa de Miguel Madina)"],
		["Don Mariano", "Chéve g̃uarã, oho ojopo Emilia Ortiz ndive, ¡Ñandejára!
(Para mí que se iba agarrado de la mano con Emilia Ortiz, ¡Dios mío!)"]
	],
	"kaloi":[
		["Kalo'i","Hola Señora, Mateo se fue derecho ko tapére, allaitee en la casa de Don Medina"]
	],
	"Piensadelfi":[
		["delfina", "Acá esta lleno de mykurẽ, ambosápe manteva'erá ko'a vícho
(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],
		["delfina", "(Presiona E para espantar animales)"]
	]
}

func _ready() -> void:
	espantad.hide()
	interac.hide()
	anima_transi_sali.play("salimos")
	await anima_transi_sali.animation_finished

	

	$npcs/npc_florida/Area3D.corpus_entro.connect(mostrar_interac)
	$npcs/npc_florida/Area3D.corpus_salio.connect(hide_interac)
	

	$"npcs/npc2-Mariano/Area3D".corpus_entro.connect(mostrar_interac)
	$"npcs/npc2-Mariano/Area3D".corpus_salio.connect(hide_interac) 
	
	
	$"npcs/kalo'i/Area3D".corpus_entro.connect(mostrar_interac)
	$"npcs/kalo'i/Area3D".corpus_salio.connect(hide_interac) 
	
	$triggers/triger_delfi.corpus_entro.connect(piensa_dialog)
	
	$"triggers/Mykure_trigger".body_entered.connect(espanta)
#on_mykure_trigger_body_entered
	

	DialogSystem.dialogo_opa.connect(dialog_terminado)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if dialogo_activo:
		# E funciona como "next" mientras el diálogo está ocurriendo
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
			
			
	elif jugador_puede_interac:
		# E inicia el diálogo si el jugador está en el área y no hay diálogo activo
		if Input.is_action_just_pressed("interaccion"):
			inic_dialo()
			
# Recibe el npc_id emitido por la señal corpus_entro del trigger
func piensa_dialog(id: String) -> void:

	if pensamiento_activo:
		return  # evita dispararse dos veces
	if not dialogos.has(id):
		return
	

	pensamiento_activo = true
	dialogo_activo = true
	jugador.puede_moverse = false
	for linea in dialogos[id]:
		DialogSystem.says(linea[1], linea[0])

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



# Se llama mediante señal cuando el DialogSystem termina todos los mensajes
func dialog_terminado() -> void:
	dialogo_activo = false
	jugador.puede_moverse = true  # desbloquea el movimiento

	# Si era un pensamiento de Delfina, destruimos el trigger y listo
	if pensamiento_activo:
		pensamiento_activo = false
		if is_instance_valid(pensamiento):
			pensamiento.queue_free()
		return

	# Si el jugador todavía está en el área de un NPC, volvemos a mostrar el label
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

# Ya no se usa directamente — la destrucción ocurre en dialog_terminado()
# Se conserva por si se necesita llamar manualmente en el futuro
func destru_piensa() -> void:
	if is_instance_valid(pensamiento):
		pensamiento.queue_free()
		
func espanta(_body):
	espantad.show()


func _on_mykure_trigger_body_exited(_body: Node3D) -> void:
	espantad.hide()



func _on_mykure_trigger_body_entered(body: Node3D) -> void:
	espantad.show()
	
