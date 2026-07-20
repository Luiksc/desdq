extends Node3D

@onready var transicion = $Control/ColorRect/AnimationPlayer
@onready var anima_kuñatai= $"kuñatai/AnimationPlayer"
@onready var kuñatai = $"kuñatai"
@onready var karau = $karau
@onready var ambos = $ojeroky
@onready var anima_ojeroky = $ojeroky/AnimationPlayer
@onready var fondo =$WorldEnvironment

@onready var anima_iru = $iru/blockbench_export/AnimationPlayer
@onready var camara = $Camera3D
@onready var destino1_camara = $punto3

var dialogo_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo

var dialogos ={
	"noticia":[
		["Kuarahy", "Anína Karáu, ani ejerokyve, agueru ndéve la noticia, nde symi omano hague.
(Por favor karau, no bailes más, te traigo la noticia del fallecimiento de tu mamá)"],
		["", "No importa mi amigo, el baile no voy a dejar, la omano ko omanóma, habrá tiempo para llorar.
(No importa mi amigo, el baile no voy a dejar, quien falleció ya falleció, habrá tiempo para llorar.)"],
	],
	
	"Piensadelfi":[
		["delfina", "Acá esta lleno de mykurẽ, ambosápe manteva'erá ko'a vícho    
(Acá está lleno de mykurés, Debo ahuyentarles a estos animales)"],               #pensamiento ejemplo
		["delfina", "(Presiona E para espantar animales)"]
	]
}

func _ready() -> void:
	DialogSystem.dialogo_opa.connect(dialog_terminado)

	$DirectionalLight3D.light_color= Color(0.269, 0.316, 0.791)
	
	
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$karau/AnimationPlayer.play("repira")
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
		anima_ojeroky.play("oñemoi")
		await anima_ojeroky.animation_finished
		
	return

	
