extends Node3D

@onready var interac: Label =$Control/Interactuar
@onready var interac2: Label =$Control/Interactuar2
@onready var interac3: Label =$Control/Interactuar3
@onready var transicion = $"Control/ã/AnimationPlayer"
@onready var data =$"Control/Data/AnimationPlayer"
@onready var boton_interac = $Control/Interac

@onready var indicador1 =$sorpresa 
@onready var indicador2 =$sorpresa2
@onready var indicador3 = $sorpresa3
@onready var jugador = $jugador

@onready var kapanga2 = $kapanga2_patrulla
@onready var kapanga3 = $kapanga3_patrulla
@onready var kapanga4 = $kapanga4_patrulla
@onready var kapanga5 =$kapanga5_patrulla
@onready var kapanga6 = $kapanga6

@onready var kapanga2_puntoorigen= $"waypoints kapanga2/Marker3D"
@onready var kapanga3_puntoorigen= $"waypoints kapanga3/Marker3D"
@onready var kapanga4_puntoorigen= $"waypoints kapanga4/Marker3D2"
@onready var kapanga5_puntoorigen= $"waypoints kapanga5/Marker3D3"
@onready var kapanga6_puntoorigen= $"waypoints kapanga6/Marker3D3"

@onready var sako_baj1 = $"objetos/sako1 baj"
@onready var sako_baj2 = $"objetos/sako2 baj"
@onready var sako_baj3 = $"objetos/sako3 baj"

@onready var sako_baj4 = $"objetos/sako4 baj"
@onready var sako_baj5 = $"objetos/sako5 baj"
@onready var sako_baj6 = $"objetos/sako6 baj"

@onready var sako_baj7 = $"objetos/sako7 baj"
@onready var sako_baj8 = $"objetos/sako8 baj"
@onready var sako_baj9 = $"objetos/sako9 baj"

@onready var flamea = $"luces/tatakua gnrl/AnimationPlayer"
@onready var perdeu = $Control/gameover
@onready var lista = $Control/Sprite2D

@export var sakos1: Array[Node3D]
var ind_sako_arriba = 0
@onready var sako_mayor =$"objetos/sako3 arrib"
@export var sakos2: Array[Node3D]
var indi_sako_bajo = 0
@onready var sako_may_bajo =$objetos/recojer

@export var sakos3: Array[Node3D]
var indice_sako_suelo=0
@onready var sako_principal=$"objetos/sako6 baj"

@export var sakos4: Array[Node3D]
var indice_sako_tata=0
@onready var trigger_main=$objetos/dejar2


@onready var anima_jugador = $jugador/blockbench_export2/AnimationPlayer
signal se_va


#tareas
var llevar :bool =false
var secar: bool = false
var comprar: bool= false



var jugom_anima_actio = true
var mykure_velocidad: float = 10
var jugador_puede_interac: bool = false
var mykure_activu: bool = false
var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false 

var puede_recoger = false
var puede_dejar = false
var llevando = false

var puede_recoger2 = false
var puede_dejar2=false
var llevando2 = false

var omano = false


var dialogos ={
	"iniciarf":[
		["Rogelio", "Mba'épa reĩ? Haimetetéma opa ko jornada chamígo.
(Qué tal está, ya casi termina esta jornada amigo mío)"],
		["Rogelio", "Eñatendéke chamígo, oje'e la kapangakuéra ipochy nendive, neranẽva'erã (nde akua va'erã)
(Prestá antencion amigo mío, se dice que los capataces se molestaron con vos, tenés que ser rápido.)"],
		["Dionisio", "Héẽ, almenos tre kósa mante ajapo'arã ha ja ahátama añeno
(Sí, almenos solo tres cosas me quedan por hacer, y después ya me acuesto.)"],
		["Rogelio", "Iporãsíto upéa, ejapysaka la llaves ipuhatã, upéa he'íse kapánga oime ag̃ui ndehegui.
che ahátama aguejy ka'a sáko amoite arriba ¡Ejúpy!"],
	],
	
	"Piensadelfi":[
		["delfina", "Acá esta lleno de mykurẽ, ambosápe manteva'erá ko'a vícho    
(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],               #pensamiento ejemplo
		["delfina", "(Presiona E para espantar animales)"]
	]
}

func _ready() -> void:
	boton_interac.hide()
	indicador1.show()
	jugador.puede_moverse= false
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	perdeu.hide()
	indicador2.hide()
	indicador3.hide()
	interac.hide()
	interac2.hide()
	interac3.hide()
	$npc_florida/Area3D.corpus_entro.connect(mostrar_interac)
	$npc_florida/Area3D.corpus_salio.connect(hide_interac)
	$inicio.oñepyru.connect(conversa)
	$Control/Sprite2D.hide()
	transicion.play("opyta")
	data.play("aparece")
	await data.animation_finished
	data.play("desaparece")
	await data.animation_finished
	transicion.play("salida")
	await transicion.animation_finished

	conversa("iniciarf")
	
	$"labura kopindo/AnimationPlayer".play("okopi")
	$"labura kopindo2/AnimationPlayer".play("okopi")
	$"labura kopindo3/AnimationPlayer".play("okopi")
	$"labura kopindo4/AnimationPlayer".play("okopi")
	sako_baj1.hide()
	sako_baj2.hide()
	sako_baj3.hide()
	
	sako_baj7.hide()
	sako_baj8.hide()
	sako_baj9.hide()



	DialogSystem.dialogo_opa.connect(dialog_terminado)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	boton_interac.play("interactura")
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
	
	if puede_recoger and llevando == false:
		if Input.is_action_just_pressed("interaccion"):
			llevando=true
			jugador.oraha=true

			recoger()
			
	if puede_dejar and llevando :
		if Input.is_action_just_pressed("interaccion"):
			oheja()
			llevando = false
			jugador.oraha= false
			print("dejado")
		
	if puede_recoger2 and llevando2 == false:
		if Input.is_action_just_pressed("interaccion"):
			llevando2=true
			jugador.oraha= true
			recoger2()
	if puede_dejar2 and llevando2:
		if Input.is_action_just_pressed("interaccion"):
			dejar2()
			llevando2=false
			jugador.oraha = false
			print("dejao
			.")
	
	if llevar == true:
		indicador1.hide()
		
	if llevar and secar == false:
		indicador2.show()
	else:
		indicador2.hide()
	if llevar and secar:
		indicador3.show()
	if omano:
		if Input.is_action_just_pressed("interaccion") or Input.is_action_just_pressed("clicki"):
			reset()

func inic_dialo() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		print("tampoco")
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
	if npc_actual == "iniciarf":
		se_va.emit()
		$Control/Sprite2D.show()
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
	interac2.show()
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		interac2.show()
		puede_recoger=true
		
func recoger():
	if sakos1.is_empty():
		return
	
	var saco = sakos1.pop_front()
	saco.hide()
	print("recogido")

	

	if sakos1.is_empty():
		if sako_mayor == null:
			pass
		else:
			sako_mayor.queue_free()
		

func oheja():
	if sakos2.is_empty():
		return
	
		
	var saco2 = sakos2.pop_front()
	saco2.show()
	match sakos2.size():
		2:
			$Control/Sprite2D/Label.text = "llevar sacos de yerba mate. 1/3"
			
		1:
			$Control/Sprite2D/Label.text= "llevar sacos de yerba mate. 2/3"
		0:
			$Control/Sprite2D/Label.text = "llevar sacos de yerba mate. 3/3"
			
			
	if sakos2.is_empty():
		sako_may_bajo.queue_free()
		print("listo")
		llevar = true

func recoger2():
	if sakos3.is_empty():
		return
	
	var saco = sakos3.pop_front()
	saco.hide()
	

	if sakos3.is_empty():
		sako_principal.queue_free()
	
func dejar2():
	if sakos4.is_empty():
		return
	var saco = sakos4.pop_front()
	saco.show()
	match sakos4.size():
		2:
			$Control/Sprite2D/Label2.text="poner a secar  la yerba. 1/3"
			
		1:
			$Control/Sprite2D/Label2.text="poner a secar  la yerba. 2/3"
		0:
			$Control/Sprite2D/Label2.text="poner a secar  la yerba. 3/3"
			secar=true
			
			
	print("dejado")
	
	if sakos4.is_empty():
		trigger_main.queue_free()

func _on_recojer_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		puede_recoger=false
		interac2.hide()

func _on_dejar_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon")or body.is_in_group("jugador_global"):
		puede_dejar = true
		if llevando:
			interac3.show()

func _on_dejar_body_exited(body: Node3D) -> void:
	puede_dejar = false
	interac3.hide()

func _on_dejar_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		interac3.show()
		puede_dejar2=true

func _on_dejar_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		interac3.hide()
		puede_dejar2=false

func _on_llevar_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		if llevar:
			interac2.show()
		
		if llevar:
			puede_recoger2 = true

func _on_llevar_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		if llevar:
			interac2.hide()
		
		if llevar:
			puede_recoger2=false

func _on_atrapado_body_entered(body: Node3D) -> void:
	oipoo()
	
func oipoo():
	omano = true
	kapanga2.velocidad = 0
	kapanga3.velocidad = 0
	kapanga4.velocidad = 0
	kapanga5.velocidad = 0
	kapanga6.velocidad = 0
	kapanga2.global_position = kapanga2_puntoorigen.global_position
	kapanga3.global_position = kapanga3_puntoorigen.global_position
	kapanga4.global_position = kapanga4_puntoorigen.global_position
	kapanga5.global_position = kapanga5_puntoorigen.global_position
	kapanga6.global_position = kapanga6_puntoorigen.global_position
	lista.hide()
	jugador.puede_moverse=false
	perdeu.show()
	boton_interac.show()
	transicion.play("entrafa")
func reset():
	
	omano = false
	var spawn = get_node_or_null("spawn")
	if spawn:
		jugador.global_position = spawn.global_position
		jugador.global_rotation = spawn.global_rotation
	boton_interac.hide()
	perdeu.hide()
	transicion.play("salida")
	await transicion.animation_finished

	lista.show()
	
	jugador.puede_moverse = true
	


	# Restaurar kapangas
	kapanga2.velocidad = 10
	kapanga3.velocidad =  10
	kapanga4.velocidad = 10
	kapanga5.velocidad =10
	kapanga6.velocidad =10

	if not llevar:

		sakos1.clear()
		sakos1.append(sako_baj1)
		sakos1.append(sako_baj2)
		sakos1.append(sako_baj3)
		for s in sakos1:
			s.show()

		sakos2.clear()
		sakos2.append(sako_baj4)
		sakos2.append(sako_baj5)
		sakos2.append(sako_baj6)
		for s in sakos2:
			s.hide()

		$Control/Sprite2D/Label.text = "Bajar sacos de yerba 0/3"

		# Resetear estado de carga de tarea 1
		llevando = false
		jugador.oraha = false


	if not secar:
	
		for s in sakos3:
			s.show()

	
		sakos4.clear()
		sakos4.append(sako_baj7)
		sakos4.append(sako_baj8)
		sakos4.append(sako_baj9)
		for s in sakos4:
			s.hide()

		$Control/Sprite2D/Label2.text = "poner a secar la yerba 0/3"

		
		llevando2 = false
		jugador.oraha = false


func _on_puerta_despensa_body_entered(body: Node3D) -> void:
	if llevar and secar:
		if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
			transicion.play("entrafa")
			await  transicion.animation_finished
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://escenarios/nivel 2/despensa ryepype.tscn")

func conversa(id_del_npc: String):
	npc_actual = id_del_npc
	inic_dialo()


#--------COlisiones de kapangas-------------------#
func _on_atrapado_4_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		oipoo()

func _on_atrapado_5_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		oipoo()

func _on_atrapado_6_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		oipoo()
		
func _on_atrapado_3_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		oipoo()
		
func _on_atrapado_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugon") or body.is_in_group("jugador_global"):
		oipoo()
