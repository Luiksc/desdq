extends Node3D

@onready var interac: AnimatedSprite2D = $Control/Interac

@onready var perder: Label = $Control/perdiendo
@onready var siguente: Label = $Control/siguietne
@onready var jugador = $jugador  # referencia al nodo del jugador
@onready var anima_jugador = $jugador/blockbench_export/AnimationPlayer
@onready var mykure = $"enemigos/mykure"
@onready var pensamiento=$triggers/triger_delfi
@onready var transicion =$"Control/ã/AnimationPlayer"
@onready var anima_datos =$Control/Datos/AnimationPlayer

@onready var checkpoint = $gestor_de_checkpoint

@onready var ambiente = $chaco_ambiente
@onready var ambiente2= $pajaros_ambiente
@onready var musica = $musica



var jugom_anima_actio = true
var jgd_omamo : bool = false
var mykure_velocidad: float = 10
var jugador_puede_interac: bool = false
var mykure_activu: bool = false
var finiquitable: bool = false

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo
var dialogos ={
	"okakula":[
		["Delfina servpin","...
(Piensa en guaraní)"],
		["Delfina","Anichéneti ko este ára niko feriado Día de la Raza.
(No puede ser hoy es feriado por Día de la Raza.)"],
],
	"florida":[
		["Ña florida","¡Qué tal Ña Delfina! ¿le buscás a Mateo?"],
		["Ña florida","Hay una fiesta cerca de la fábrica por el día de la Raza"],
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
	siguente.hide()
	$Control/Label.hide()
	perder.hide()
	interac.hide()
	transicion.play("opyta")
	anima_datos.play("aparece")
	await anima_datos.animation_finished
	anima_datos.play("desaparece")
	await anima_datos.animation_finished
	transicion.play("salida")
	await transicion.animation_finished

	
	$npcs/npc_florida/Area3D.corpus_entro.connect(mostrar_interac)
	$npcs/npc_florida/Area3D.corpus_salio.connect(hide_interac)
	

	$"npcs/npc2-Mariano/Area3D".corpus_entro.connect(mostrar_interac)
	$"npcs/npc2-Mariano/Area3D".corpus_salio.connect(hide_interac) 
	
	
	$"npcs/kalo'i/Area3D".corpus_entro.connect(mostrar_interac)
	$"npcs/kalo'i/Area3D".corpus_salio.connect(hide_interac) 
	
	$triggers/triger_delfi.corpus_entro.connect(piensa_dialog)
	
	$"triggers/Mykure_trigger".body_entered.connect(espanta)
	
	$"enemigos/mykure/Area3D_daña".jgd_omano.connect(jugador_omano)
	$"enemigos/mykure2/Area3D_daña2".jgd_omano.connect(jugador_omano)
	$"enemigos/mykure3/Area3D_daña3".jgd_omano.connect(jugador_omano)
#on_mykure_trigger_body_entered
	

	DialogSystem.dialogo_opa.connect(dialog_terminado)

	delfi_okalkula("okakula")

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
	if jgd_omamo: 
		if Input.is_action_just_pressed("clicki") or Input.is_action_just_pressed("interaccion"):
			print("reset")
			reset()
	
# Recibe el npc_id emitido por la señal corpus_entro del trigger
func piensa_dialog(id: String) -> void:

	if pensamiento_activo:
		return  # evita dispararse dos veces
	if not dialogos.has(id):
		return
	

	pensamiento_activo = true
	dialogo_activo = true
	jugador.puede_moverse = false
	jugom_anima_actio = false
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
	interac.play()
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
	interac.show()
	interac.play()


func _on_mykure_trigger_body_exited(_body: Node3D) -> void:
	interac.hide()



func _on_mykure_trigger_body_entered(body: Node3D) -> void:
	interac.show()
	interac.play()
	


func _on_final_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		jugador.puede_moverse=false
		Input.mouse_mode= Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://escenarios/n_1_cinema_final.tscn")
		finiquitable = true
func jugador_omano():
	ambiente.stop()
	ambiente2.stop()
	musica.stop()
	transicion.play("entrafa")
	await transicion.animation_finished
	jugador.puede_moverse = false
	jgd_omamo=true
	perder.show()
	$Control/Label.show()
	
	
func reset():
	perder.hide()
	$Control/Label.hide()#escondete kape
	
	jgd_omamo=false
	jugador.global_position = checkpoint.ultima_posicion
	transicion.play("salida")
	jugador.puede_moverse=true
	ambiente.play()
	ambiente2.play()
	musica.play()
		


func _on_zonademuerte_body_entered(body: Node3D) -> void:
	jugador_omano()


func _on_zonademuerte_2_body_entered(body: Node3D) -> void:
	jugador_omano()
func delfi_okalkula(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
	
	
