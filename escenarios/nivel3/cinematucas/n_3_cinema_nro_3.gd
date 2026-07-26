extends Node3D

@onready var transicion = $Control/ColorRect/AnimationPlayer
@onready var transicion_pixel = $"Control/ã/AnimationPlayer"
@onready var jugador = $karau
@onready var timer = $Timer2
@onready var prim_timer = $Timer3
@onready var anima_tekoha = $WorldEnvironment/AnimationPlayer
@onready var musica_divina 

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false

@onready var timero = $Timer

var dialogos ={
	"noticia":[
		["Karãu", "MBA'ÉICHAIKO NAÑATENDEMO'AI CHE TIEMPO REHE, HA MOO PIKO OIME RÓGA
(CÓMO NO VOY A ATENDER MI TIEMPO, Y DÓNDE ESTÁ MI CASA)"],
		["Karãu", "ANICHÉNE AKAÑY... ¡MAMÁ!
(NO ME DIGAS QUE ME PERDÍ...¡MAMÁ!)"],
	],
	"tupa":[
		["Tupã", "Mitã Karãu, ne mitãrusu akãhatã, tova'atã ha nderehechakuaái guive.
(Karãu, por ser un hijo travieso, cara dura y faltante de empatía)"],
		["Tupã", "Oikóta ndehegui mymba, ha hasẽhape reikóta.
(En una criatura te convertirás, y entre llano vivirás)"],
	]
}

func _ready() -> void:
	
	transicion_pixel.play("salida")
	MusicaGlobal.play_music_level()
	MusicaGlobal.jui_sonido_ambiental()
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	timer.start()
	await timer.timeout
	asigna_id("noticia")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
		

func asigna_id(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
	if id_del_npc == "noticia":
		await get_tree().create_timer(30.0).timeout
		if dialogo_activo and npc_actual == "noticia":
			DialogSystem.terminar_dialogo()

func inic_dialo() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		print("tampoco")
		return
	
	dialogo_activo = true
	
	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])

	 # bloquea el movimiento del jugador
	#DialogSystem.says("¿No te enteraste de la fiesta que hizo la fábrica por el Día de la Raza ? Todos están ahí; seguramente Mateo también.", "Ña Clotilde")

# Se llama mediante señal cuando el DialogSystem termina todos los mensajes
func dialog_terminado() -> void:
	dialogo_activo = false

	if pensamiento_activo:
		pensamiento_activo = false
	if npc_actual == "noticia":
		tupa()
	if npc_actual == "tupa":
		transicion.play("aparece")
		await transicion.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel3/cinematucas/n3_cinema_Final.tscn")
	return

func tupa():
	timero.start()
	await timero.timeout
	anima_tekoha.play("trueno")
	$RayosYTruenosN3.play()
	timero.start()
	await get_tree().create_timer(15.0).timeout
	anima_tekoha.play("trueno")
	$RayosYTruenosN3.play()
	$Timer2.start()
	await $Timer2.timeout
	jugador.puede_moverse=false
	asigna_id("tupa")
	
