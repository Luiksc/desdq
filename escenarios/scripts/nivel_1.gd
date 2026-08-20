extends Node3D

@onready var interac: AnimatedSprite2D = $Control/Interac
@onready var sorpresa_npc1 = $npcs/npc_florida/sorpresa
@onready var sorpresa_npc2 = $"npcs/npc2-Mariano/sorpresa2"
@onready var sorpresa_npc3 = $"npcs/kalo'i/sorpresa3"

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
@onready var daña = $"UndertaleDamageSoundEffect(mp3Cut_net)"


var jugom_anima_actio = true
var jgd_omamo : bool = false
var muriendo: bool = false  # bloquea llamadas concurrentes a jugador_omano()
var mykure_velocidad: float = 10
var jugador_puede_interac: bool = false
var mykure_activu: bool = false
var finiquitable: bool = false

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo
var dialogos ={
	"okakula":[
		["Delfina servín","...
(Piensa)"],
		["Delfina","Moõguipa ahendu pe música 
(¿De donde viene esa música?)"],
		["Delfina", "Ha Mateo ndojevýiti.
(Y Mateo aún no vuelve.)"],
		["Delfina","Iñestrañoléntoma
(Es algo raro.)"]
],
	"florida":[
		["Ña florida","Mba'éichapa Ña Delfina!
(¡Cómo estás Delfina!)"],
		["Ña florida","Henyhẽta ra'e aipo fárra, ohopaitéma lo mitã.
(Se llena había sido la fiesta, se van todo los chicos.)"]
],
	"Mariano":[
		["Don Mariano", "Mba'éichapa Ña Servín
(Cómo está Doña Servín)"],
		["Don Mariano", "¿Mateo? Heẽ, aje'íma ndatopavéima chupe...
(¿Mateo? Sí, hace rato que no le encuentro...)"],
		["Don Mariano", "Ikatu ajavy hína péro.
(Puede que me equivoque pero)"],
		["Don Mariano","Ndohói niko ha'eño
(No se iba él solo)"]
	],
	"kaloi":[
		["Kalo'i","Hola Señora."],
		["Kalo'i","¡Karai Mateo ohokuri pya'e pya'e ko tapére!"]
	],
	"Piensadelfi":[
		["delfina", "Chejokopa ko'ã mykurẽ, ambosápe manteva'erá ko'ã vícho
(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],
		["delfina", "(Presiona E para espantar animales)"]
	]
}

func _ready() -> void:
	$Control/CanvasLayer.hide()
	jugador.puede_moverse = false
	siguente.hide()
	
	$Control/Label.hide()
	perder.hide()
	interac.hide()
	transicion.play("opyta")
	anima_datos.play("aparece")
	await anima_datos.animation_finished
	anima_datos.play("desaparece")
	await anima_datos.animation_finished
	$Control/CanvasLayer.show()
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

	

	DialogSystem.dialogo_opa.connect(dialog_terminado)

	delfi_okalkula("okakula")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	interac.play()
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
	elif jugador_puede_interac:
		if Input.is_action_just_pressed("interaccion"):
			$DialogSystem/sound.play()
			inic_dialo()
	if jgd_omamo: 
		if Input.is_action_just_pressed("clicki") or Input.is_action_just_pressed("interaccion"):
			$"8BitCoinSoundEffect".play()
			reset()
	

func piensa_dialog(id: String) -> void:

	if pensamiento_activo:
		return  
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
		
	if npc_actual == "florida":
		sorpresa_npc1.hide()
	elif npc_actual == "Mariano":
		sorpresa_npc2.hide()
	elif npc_actual == "kaloi":
		sorpresa_npc3.hide()
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

func _on_final_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		jugador.puede_moverse=false
		Input.mouse_mode= Input.MOUSE_MODE_VISIBLE
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://escenarios/n_1_cinema_final.tscn")
		finiquitable = true
func jugador_omano():

	if muriendo or jgd_omamo:
		return
	muriendo = true
	jugador.puede_moverse = false
	$Control/CanvasLayer.hide()
	daña.play()
	ambiente.stop()
	ambiente2.stop()
	musica.stop()
	transicion.play("entrafa")
	
	await transicion.animation_finished
	
	jgd_omamo = true
	muriendo = false
	perder.show()
	interac.show()
	$Control/Label.show()
	
	
func reset():
	if not jgd_omamo:
		return
	
	jgd_omamo = false
	muriendo = false
	perder.hide()
	interac.hide()
	$Control/Label.hide()
	$Control/CanvasLayer.show()
	
	# Reposicionar jugador y limpiar velocidad residual
	jugador.global_position = checkpoint.ultima_posicion
	if jugador is CharacterBody3D:
		jugador.velocity = Vector3.ZERO
	
	# Reiniciar enemigos para evitar spawn-kill
	if mykure and mykure.has_method("reinicio"):
		mykure.reinicio()
	if has_node("enemigos/mykure2") and $"enemigos/mykure2".has_method("reinicio"):
		$"enemigos/mykure2".reinicio()
	if has_node("enemigos/mykure3") and $"enemigos/mykure3".has_method("reinicio"):
		$"enemigos/mykure3".reinicio()
	
	transicion.play("salida")
	await transicion.animation_finished
	
	jugador.puede_moverse = true
	ambiente.play()
	ambiente2.play()
	musica.play()
		


func _on_zonademuerte_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		jugador_omano()


func _on_zonademuerte_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		jugador_omano()
func delfi_okalkula(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
	
	
