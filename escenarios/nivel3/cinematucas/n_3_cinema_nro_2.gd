extends Node3D

@onready var transicion = $Control/ColorRect/AnimationPlayer

@onready var karau = $karau
@onready var karau2 = $karau2
@onready var anima_karau2 =$karau2/AnimationPlayer
@onready var anima_karau2_oho= $karau2/AnimationPlayer2
@onready var anima_karau= $karau/AnimationPlayer
@onready var anima_kuñatai = $"kuñatai/AnimationPlayer"

@onready var camara = $Camera3D

@onready var destino_camara= $final

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo

var dialogos ={
	"noticia":[
		["Karau", "Ipytũmbáma, .¿Mámopa opyta nde róga?
(Ya obscureció todo, ¿Por dónde está tu casa?)"],
		["Arami", "Ndaimombyrýi che róga chevisitaserõ...
(Mi casa no está lejos si me queres visitar)"],
		["Arami", "Rehechaga'úne nde sy...
(Haz de extrañar a tu mamá)"],
	]
}

func _ready() -> void:
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	karau2.hide()
	asigna_id("noticia")


func _process(delta: float) -> void:
	anima_karau.play("repira")
	anima_kuñatai.play("repira")
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()

func asigna_id(id_del_npc: String) ->void:
	npc_actual = id_del_npc
	inic_dialo()
	

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
		karau.hide()
		karau2.show()
		camara.position = destino_camara.position
		anima_karau2.play("ndoroviai")
		anima_karau2_oho.play("OHO")
		await anima_karau2_oho.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel3/cinematucas/n3_cinema-nro3.tscn")
		
	return

	
