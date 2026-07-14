extends Node

var posicion1 : Vector3
var posicion2 : Vector3
var final = false

@onready var final_punto = $final
@onready var jugador =$karau
@onready var control_camara = $karau/pivote
@onready var anima_jugon = $karau/blockbench_export/AnimationPlayer
@onready var tri_fr = $objetos/casa1/trigger_farra
@onready var interac = $Control/interac
@onready var dialogo_piensa = $objetos/casa1

@onready var puntos_spawn: Node =$"posible aparecer ka'arurupa"
@onready var kaarurupa: Resource = preload("res://escenarios/nivel3/ka'arurupa.tscn")

@onready var puntos_spawn2: Node  = $"posible_aparecer_ka'are"
@onready var kaare: Resource= preload("res://escenarios/nivel3/ka'are.tscn")

@onready var puntos_spawn3 : Node = $"posible_aparecer_amba'y"
@onready var ambay: Resource = preload("res://escenarios/nivel3/ambay.tscn")

@onready var lista =$Control/ItemList

# Referencia al contenedor de cápsulas
@onready var capsulas_yuyo: Node3D = $capsulas_yuyo

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo

#-----pohañana------


var omano = false

# Lista que acumula los identificadores de objetos recogidos por el jugador
var objetos_recogidos: String


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
	interac.hide()
	randomize()
	spawn_yuyo1()
	spawn_yuyo2()
	spawn_yuyo3()
	
	DialogSystem.dialogo_opa.connect(dialog_terminado)




func spawn_yuyo1():
	var instancia_yuyo: Node3D = kaarurupa.instantiate()
	add_child(instancia_yuyo)
	
	instancia_yuyo.jugador_entro.connect(_on_objeto_recogido)

	var marcadores: Array[Marker3D] = []

	for hijo in puntos_spawn.get_children():
		if hijo is Marker3D:
			marcadores.append(hijo)

	if marcadores.is_empty():
		push_error("No hay Marker3D para hacer spawn.")
		return

	var idx : int = randi() % marcadores.size()
	var marcador : Marker3D = marcadores[idx]
	instancia_yuyo.global_position = marcador.global_position

	
	var nombres_capsulas = ["mymba1_kaarurupa", "mymba2_kaarurupa", "mymba3_kaarurupa"]
	var capsula = capsulas_yuyo.get_node_or_null(nombres_capsulas[idx])
	if capsula:
		capsula.id_yuyo_esperado = "ka'arurupa"
		capsula.vincular_yuyo(instancia_yuyo)

func spawn_yuyo2():
	var instancia_yuyo: Node3D = kaare.instantiate()
	add_child(instancia_yuyo)

	instancia_yuyo.jugador_entro.connect(_on_objeto_recogido)

	var marcadores: Array[Marker3D] = []

	for hijo in puntos_spawn2.get_children():
		if hijo is Marker3D:
			marcadores.append(hijo)

	if marcadores.is_empty():
		push_error("No hay Marker3D para hacer spawn.")
		return

	var idx : int = randi() % marcadores.size()
	var marcador : Marker3D = marcadores[idx]
	instancia_yuyo.global_position = marcador.global_position

	
	var nombres_capsulas = ["mymba4_kaare", "mymba5_kaare", "mymba6_kaare"]
	var capsula = capsulas_yuyo.get_node_or_null(nombres_capsulas[idx])
	if capsula:
		capsula.id_yuyo_esperado = "ka'aré"
		capsula.vincular_yuyo(instancia_yuyo)

func spawn_yuyo3():
	var instancia_yuyo: Node3D = ambay.instantiate()
	add_child(instancia_yuyo)

	instancia_yuyo.jugador_entro.connect(_on_objeto_recogido)

	var marcadores: Array[Marker3D] = []

	for hijo in puntos_spawn3.get_children():
		if hijo is Marker3D:
			marcadores.append(hijo)

	if marcadores.is_empty():
		push_error("No hay Marker3D para hacer spawn.")
		return

	var idx : int = randi() % marcadores.size()
	var marcador : Marker3D = marcadores[idx]
	instancia_yuyo.global_position = marcador.global_position

	
	var nombres_capsulas = ["mymba7_ambay", "mymba8_ambay", "mymba9_ambay"]
	var capsula = capsulas_yuyo.get_node_or_null(nombres_capsulas[idx])
	if capsula:
		capsula.id_yuyo_esperado = "amba'y"
		capsula.vincular_yuyo(instancia_yuyo)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if final:
		ohotama()
		
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
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

# Se llama cuando el jugador entra al área de un objeto recolectable.
# Recibe el identificador del objeto y lo añade a la lista de recogidos.

func _on_objeto_recogido(id: String) -> void:
	objetos_recogidos = id
	print(objetos_recogidos) 
	if objetos_recogidos == "ambay":
		$DialogSystem/sound.play()
		lista.set_item_text(0, "Erekóma Amba'y")
		
	elif objetos_recogidos == "ka'arurupa":
		$DialogSystem/sound.play()
		lista.set_item_text(1, "Erekóma Ka'arurupa")
		
	if objetos_recogidos == "ka'aré":
		$DialogSystem/sound.play()
		lista.set_item_text(2, "Erekóma Ka'aré")
