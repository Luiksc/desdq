extends Node3D

@onready var transicion = $Control/ColorRect/AnimationPlayer
@onready var jugador = $karau
@onready var timer = $Timer2
@onready var prim_timer = $Timer3

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false
 # true mientras el diálogo de pensamiento está corriendo
@onready var timero = $Timer

var dialogos ={
	"noticia":[
		["Karau", "MBA'ÉICHAIKO NAÑATENDEMO'AI CHE TIEMPO REHE, HA MOO PIKO OIME RÓGA
(CÓMO NO VOY A ATENDER MI TIEMPO, Y DÓNDE ESTÁ MI CASA)"],
		["Karaú", "ANICHÉNE AKAÑY... ¡MAMÁ!
(NO ME DIGAS QUE ME PERDÍ...¡MAMÁ!)"],
	]
}

func _ready() -> void:
	
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	timer.start()
	await timer.timeout
	asigna_id("noticia")
	
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await prim_timer.timeout
	dialog_terminado()
	
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
		

func asigna_id(id_del_npc: String) ->void:
	npc_actual = id_del_npc
	inic_dialo()
	

func inic_dialo() -> void:
	prim_timer.start()
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
		timero.start()
		await timero.timeout
		print("tupak")
	return
