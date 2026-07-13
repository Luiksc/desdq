extends Node

var posicion1 : Vector3
var posicion2 : Vector3
var final = false

@onready var final_punto = $final
@onready var jugador =$dionisio
@onready var control_camara = $dionisio/pivote
@onready var anima_jugon = $dionisio/blockbench_export/AnimationPlayer

@onready var tri_fr = $objetos/casa1/trigger_farra
@onready var puntos_spawn: Node =$"posible aparecer ka'arurupa"
@onready var kaarurupa: Resource = preload("res://escenarios/nivel3/ka'arurupa.tscn")
@onready var interac = $Control/interac
@onready var dialogo_piensa = $objetos/casa1

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo


var omano = false


var dialogos ={
	"florida":[
		["Ña florida","¡Qué tal Ña Delfina! ¿le buscás a Mateo?"],                #ejemplo
		["Ña florida","Hay una fiesta cerca de la fábrica por el día de la Raza"],
		["Ña florida","Ikatu Mateo ohora'e napépe.
(seguro se fue allá)"]
	],
	"pensamiento":[
		["Karáu", "Ahasamíta ko fárrare, sapy'aiténte.
(Voy a la fiesta, un ratito nomás.)"],
		
	],
	
	"Piensadelfi":[
		["delfina", "Acá esta lleno de mykurẽ, ambosápe manteva'erá ko'a vícho    
(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],               #pensamiento ejemplo
		["delfina", "(Presiona E para espantar animales)"]
	]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawn_yuyo()
	DialogSystem.dialogo_opa.connect(dialog_terminado)



func spawn_yuyo():
	var instancia_yuyo: Node3D = kaarurupa.instantiate()
	add_child(instancia_yuyo)

	var marcadores: Array[Marker3D] = []

	for hijo in puntos_spawn.get_children():
		if hijo is Marker3D:
			marcadores.append(hijo)

	if marcadores.is_empty():
		push_error("No hay Marker3D para hacer spawn.")
		return

	var marcador : Marker3D = marcadores.pick_random()
	instancia_yuyo.global_position = marcador.global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if final:
		ohotama()
		
	if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
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
	
	if npc_actual == "pensamiento":
		final = true 
		control_camara.cinematica = false 
		
	# Si era un pensamiento de Delfina, destruimos el trigger y listo
	if pensamiento_activo:
		pensamiento_activo = false
		#if is_instance_valid(pensamiento):
		#	pensamiento.queue_free()
		return

	# Si el jugador todavía está en el área de un NPC, volvemos a mostrar el label
	#if jugador_puede_interac:
	#	interac.show()

func mostrar_interac(id_del_npc: String) -> void:
	interac.show()
	#jugador_puede_interac = true
	npc_actual = id_del_npc
# El jugador sale del área del NPC
func hide_interac(id_del_npc: String) -> void:
	if npc_actual == id_del_npc:
		interac.hide()
	#	jugador_puede_interac = false
		npc_actual=""
	# Si se va mientras hay un diálogo activo, reseteamos y desbloqueamos
	if dialogo_activo:
		dialogo_activo = false
		jugador.puede_moverse = true



func _on_trigger_farra_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		
		control_camara.posiciona()
		jugador.farra = true
		jugador.puede_moverse = false
		control_camara.cinematica = true  # era .farra, pero el pivote usa .cinematica para bloquear el mouse
		anima_jugon.play("repiraomañavo")
		await anima_jugon.animation_finished
		 # espera que termine la animación cinemática
		piensa("pensamiento")
		# --- fin cinemática ---
				 # desbloquea el movimiento del jugador
		   # devuelve el control de cámara al jugador
			  # vuelve a la animación idle
func ohotama():
	var direccion = final_punto.global_position - jugador.global_position
	direccion.y = 0
	direccion = direccion.normalized()
	jugador.velocity = direccion * 8
	if anima_jugon.current_animation != "oho":
		anima_jugon.play("oho")

	jugador.move_and_slide()
func piensa(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
