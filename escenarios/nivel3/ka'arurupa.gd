extends Node

var posicion1 : Vector3
var posicion2 : Vector3
var final = false
var ikatu_oho = false
var perder = false

@onready var transicion = $"Control/ã/AnimationPlayer"
@onready var final_punto = $final
@onready var perdeu = $Control/eñehundi
@onready var boton_perdeu = $Control/interaccion2
@onready var jugador =$karau
@onready var control_camara = $karau/pivote
@onready var anima_jugon = $karau/karau/AnimationPlayer
@onready var tri_fr = $objetos/casa1/trigger_farra
@onready var daña = $"UndertaleDamageSoundEffect(mp3Cut_net)"

@onready var dialogo_piensa = $objetos/casa1

#-----pohañana------
@onready var puntos_spawn: Node =$"posible aparecer ka'arurupa"
@onready var kaarurupa: Resource = preload("res://escenarios/nivel3/ka'arurupa.tscn")

@onready var puntos_spawn2: Node  = $"posible_aparecer_ka'are"
@onready var kaare: Resource= preload("res://escenarios/nivel3/ka'are.tscn")

@onready var puntos_spawn3 : Node = $"posible_aparecer_amba'y"
@onready var ambay: Resource = preload("res://escenarios/nivel3/ambay.tscn")

@onready var lista =$Control/lista


@onready var enemigos_yuyo: Node3D = $enemigos_yuyo

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  


var omano = false


var objetos_recogidos: String


var posicion_inicial_jugador: Vector3


var instancia_kaarurupa: Node3D = null
var instancia_kaare: Node3D = null
var instancia_ambay: Node3D = null


var reseteando: bool = false


var dialogos ={
	"inicio":[
		["Karãu","Akói la ñanandy imymbareta, amondýita mante umi mymba ka'aguy.
(Siempre hay muchos animales en el yuyal, voy a espantarles nomas a estos animales salvajes)"],            
		["Karãu","(Seguí el patrón de teclas para espantar animales.)"],
	],
	"pensamiento1":[
		["Karãu", "Emañamína mba'eichaite iporã pe kuñataĩ.\n(Que hermosa es esa chica.)"]
	],
	"pensamiento2":[
		["Karãu", "Ahasamíta ko fárrare, sapy'aiténte.\n(Voy a la fiesta, un ratito nomás.)"],
		
	],
	
	"Piensakarau":[
		["Karãu", "    \n(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],               #pensamiento ejemplo
		["delfina", "(Presiona E para espantar animales)"]
	]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicaGlobal.tortola_sonido_ambiente()
	piensa1("inicio")
	perdeu.hide()
	boton_perdeu.hide()
	transicion.play("salida")
	await transicion.animation_finished
	lista.show()
	randomize()
	posicion_inicial_jugador = jugador.global_position
	
	spawn_yuyo1()
	spawn_yuyo2()
	spawn_yuyo3()
	
	DialogSystem.dialogo_opa.connect(dialog_terminado)

func hay_mymba_persiguiendo() -> bool:
	for m in get_tree().get_nodes_in_group("mymba"):
		if m.get("persigue") == true:
			return true
	return false
	
func spawn_yuyo1():
	
	if instancia_kaarurupa != null and is_instance_valid(instancia_kaarurupa):
		instancia_kaarurupa.queue_free()
		instancia_kaarurupa = null
	
	var instancia_yuyo: Node3D = kaarurupa.instantiate()
	add_child(instancia_yuyo)
	instancia_kaarurupa = instancia_yuyo
	
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

	
	var nombres_enemigos= ["mymba1_kaarurupa", "mymba2_kaarurupa", "mymba3_kaarurupa"]
	var enemigo = enemigos_yuyo.get_node_or_null(nombres_enemigos[idx])
	if enemigo:
		enemigo.id_yuyo_esperado = "ka'arurupa"
		enemigo.vincular_yuyo(instancia_yuyo)
	_conectar_daña_grupo("ka'arurupa")

func spawn_yuyo2():

	if instancia_kaare != null and is_instance_valid(instancia_kaare):
		instancia_kaare.queue_free()
		instancia_kaare = null
	
	var instancia_yuyo: Node3D = kaare.instantiate()
	add_child(instancia_yuyo)
	instancia_kaare = instancia_yuyo

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

	
	var nombres_enemigos = ["mymba4_kaare", "mymba5_kaare", "mymba6_kaare"]
	var enemigos= enemigos_yuyo.get_node_or_null(nombres_enemigos[idx])
	if enemigos:
		enemigos.id_yuyo_esperado = "ka'aré"
		enemigos.vincular_yuyo(instancia_yuyo)
	
	_conectar_daña_grupo("ka'aré")

func spawn_yuyo3():

	if instancia_ambay != null and is_instance_valid(instancia_ambay):
		instancia_ambay.queue_free()
		instancia_ambay = null
	
	var instancia_yuyo: Node3D = ambay.instantiate()
	add_child(instancia_yuyo)
	instancia_ambay = instancia_yuyo

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

	
	var nombres_enemigos = ["mymba7_ambay", "mymba8_ambay", "mymba9_ambay"]
	var enemigos = enemigos_yuyo.get_node_or_null(nombres_enemigos[idx])
	if enemigos:
		enemigos.id_yuyo_esperado = "amba'y"
		enemigos.vincular_yuyo(instancia_yuyo)
	
	_conectar_daña_grupo("amba'y")


func _conectar_daña_grupo(id_yuyo: String) -> void:
	
	await get_tree().process_frame
	for m in get_tree().get_nodes_in_group("mymba"):
		if m.get("id_yuyo_esperado") == id_yuyo:
			if m.has_signal("jugador_danado"):
				if not m.jugador_danado.is_connected(_on_jugador_danado):
					m.jugador_danado.connect(_on_jugador_danado)



func _on_jugador_danado(id_yuyo: String) -> void:
	if reseteando:
		return
	reseteando = true
	print("Jugador dañado, Reseteando yuyo: ", id_yuyo)
	await reset_por_yuyo(id_yuyo)
	reseteando = false

func reset_por_yuyo(id_yuyo: String) -> void:
	daña.play()
	for m in get_tree().get_nodes_in_group("mymba"):
		if m.has_method("volver_a_origen"):
			m.volver_a_origen()
		m.set("persigue", false)
	

	if jugador != null and jugador.has_method("resetear_combo"):
		jugador.resetear_combo()
	if control_camara != null:
		if control_camara.has_method("opa_combo"):
			control_camara.opa_combo()
			
		else:
			control_camara.cinematica = false
	
	transicion.play("entrafa")
	await transicion.animation_finished
	perdeu.show()
	boton_perdeu.show()
	$Control/lista.hide()
	perder = true
	match id_yuyo:
		"ka'arurupa":
			$Control/lista/Label2.text = "Ka'arurupa 0/1"
			spawn_yuyo1()
		"ka'aré":
			$Control/lista/Label3.text = "Ka'aré 0/1"
			spawn_yuyo2()
		"amba'y":
			$Control/lista/Label.text = "Amba'y 0/2"
			spawn_yuyo3()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"kuñatai/AnimationPlayer".play("sentada")
	if final:
		ohotama(delta)
		
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
	if ikatu_oho:
		ohota_primio()
	if perder:
		if Input.is_action_just_pressed("interaccion") or Input.is_action_just_pressed("clicki"):
			$"8BitCoinSoundEffect".play()
			perder = false
			jugador.global_position = posicion_inicial_jugador
			jugador.velocity = Vector3.ZERO
			jugador.puede_moverse = true
			transicion.play("salida")
			perdeu.hide()
			boton_perdeu.hide()
			$Control/lista.show()
	
	#
			anima_jugon.play("repira")
	
func inic_dialo() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		
		return
	dialogo_activo = true
	
	jugador.puede_moverse = false
	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])

func dialog_terminado() -> void:
	dialogo_activo = false
	

	if npc_actual == "pensamiento1":
		ikatu_oho = true 
		return  
		
	if npc_actual == "pensamiento2":
		final = true  
		return  
	

	jugador.puede_moverse = true
	

	if pensamiento_activo:
		pensamiento_activo = false
		return
func mostrar_interac(id_del_npc: String) -> void:
	npc_actual = id_del_npc

func hide_interac(id_del_npc: String) -> void:
	if npc_actual == id_del_npc:
	
	
		npc_actual=""
	
	if dialogo_activo:
		dialogo_activo = false
		jugador.puede_moverse = true


func _on_trigger_farra_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):		# Bloquear si algún mymba está persiguiendo al jugador
		if hay_mymba_persiguiendo():
			return
		tri_fr.queue_free()
		piensa1("pensamiento1")

func ohotama(delta: float):
	control_camara.cinematica = true
	var direccion = final_punto.global_position - jugador.global_position
	direccion.y = 0
	var distancia = direccion.length()
	if direccion.length() > 0.01:
		# Karau tiene el frente en +X, por eso se usa atan2(z, x)
		var angulo = atan2(direccion.z, direccion.x)
		jugador.rotation.y = lerp_angle(jugador.rotation.y, angulo, 10.0 * delta)
	direccion = direccion.normalized()
	jugador.velocity = direccion * 8
	if anima_jugon.current_animation != "oho":
		anima_jugon.play("oho")
	jugador.move_and_slide()
	if distancia <= 1:
		jugador.puede_moverse = false
		transicion.play("entrafa")
		get_tree().change_scene_to_file("res://escenarios/nivel3/cinematicas/n3_cinema-nro.tscn")
		

func piensa2(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
func piensa1(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
	
func ohota_primio():
	ikatu_oho = false 
	
	control_camara.posiciona()
	jugador.farra = true
	jugador.puede_moverse = false
	control_camara.cinematica = true  
	anima_jugon.play("repiraomañavo")
	await anima_jugon.animation_finished
	piensa2("pensamiento2")
	
func _on_objeto_recogido(id: String) -> void:
	objetos_recogidos = id
	print(objetos_recogidos) 
	if objetos_recogidos == "ambay":
		$DialogSystem/sound.play()
		$Control/lista/Label.text = "Amba'y 1/2"
		
	elif objetos_recogidos == "ka'arurupa":
		$DialogSystem/sound.play()
		$Control/lista/Label2.text = "Ka'arurupa 1/1"
		
	if objetos_recogidos == "ka'aré":
		$DialogSystem/sound.play()
		$Control/lista/Label3.text = "Ka'aré 1/1"
