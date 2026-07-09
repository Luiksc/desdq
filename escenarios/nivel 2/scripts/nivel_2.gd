extends Node3D

@onready var interac: Label =$Control/Interactuar
@onready var interac2: Label =$Control/Interactuar2
@onready var jugador = $jugador
@onready var sako_mayor =$"objetos/sako1 arrib"
@onready var flamea = $"luces/tatakua gnrl/AnimationPlayer"
@onready var lista = $Control/ItemList

@export var sakos1: Array[Node3D]
var ind_sako_arriba = 0

var jugom_anima_actio = true
var mykure_velocidad: float = 10
var jugador_puede_interac: bool = false
var mykure_activu: bool = false
var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo
var puede_recoger = false
var llevando = false

var dialogos ={
	"florida":[
		["Ña florida","¡Qué tal Ña Delfina! ¿le buscás a Mateo?"],                #ejemplo
		["Ña florida","Hay una fiesta cerca de la fábrica por el día de la Raza"],
		["Ña florida","Ikatu Mateo ohora'e napépe.
(seguro se fue allá)"]
],
	"Piensadelfi":[
		["delfina", "Acá esta lleno de mykurẽ, ambosápe manteva'erá ko'a vícho    
(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],               #pensamiento ejemplo
		["delfina", "(Presiona E para espantar animales)"]
	]
}

func _ready() -> void:
	interac.hide()
	interac2.hide()

	$npc_florida/Area3D.corpus_entro.connect(mostrar_interac)
	$npc_florida/Area3D.corpus_salio.connect(hide_interac)
	

	DialogSystem.dialogo_opa.connect(dialog_terminado)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	flamea.play("flamea")
	if dialogo_activo:
		# E funciona como "next" mientras el diálogo está ocurriendo
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
			
			
	elif jugador_puede_interac:
		# E inicia el diálogo si el jugador está en el área y no hay diálogo activo
		if Input.is_action_just_pressed("interaccion"):
			inic_dialo()
	if puede_recoger:
		if Input.is_action_just_pressed("interaccion"):
			lista.remove_item(2)
			recoger()
		
		
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
		#if is_instance_valid(pensamiento):
		#	pensamiento.queue_free()
		return

	# Si el jugador todavía está en el área de un NPC, volvemos a mostrar el label
	if jugador_puede_interac:
		interac.show()

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


func _on_recojer_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		interac2.show()
		puede_recoger=true
		print(sakos1.size())
		
			
func recoger():
	if sakos1.is_empty():
		return
		
	if ind_sako_arriba >= sakos1.size():
		return
	
	var saco = sakos1.pop_front()
	saco.hide()

	if sakos1.is_empty():
		sako_mayor.queue_free()
		
	#sakos1[ind_sako_arriba].hide()
	#print(sakos1.size())
	#ind_sako_arriba +=  1
	
	#if ind_sako_arriba >= sakos1.size():
		#print("ya eta")
		#sako_mayor.queue_free()

		

func _on_recojer_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		interac2.hide()
