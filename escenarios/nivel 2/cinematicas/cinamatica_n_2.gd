extends Node3D

@onready var cine = $AnimationPlayer
@onready var dio =$dio
@onready var transi =$"Control/ã/AnimationPlayer"
@onready var time = $Timer
@onready var camara =$Camera3D
@onready var carto =$Control/final/AnimationPlayer
@onready var fondo_carat = $Control/final
@onready var anima_boton = $Control/final/Button/AnimationPlayer
@onready var anima_qr = $Control/final/Sprite2D/AnimationPlayer

var fino = false

var dialogo_activo: bool = false
var npc_actual: String = ""
var dialogos ={
	"conversa":[
		["Dionisio","Marta, Nereñenoiti ra'e.
(Marta, aún no te acostasta había sido."],
		["Marta","¡Dionisio!, Ne'ira ndajarreglapai la héfe sombréro.
(¡Dionisio!, todavía no arregle todo el sombrero del jefe.)"],
		["Marta","Chekane'õiterei, ko este día rojara y elisa ndive, roipiro mandi'o ha rojarregla sombrerokuéra
(Estoy muy cansada, hoy acarreamos agua con Elisa, pelamos mandiocas y arreglamos sombreros.)"],
		["Marta", "¿Ndikatúiko jasyryry ka'aguýre ha ñasẽ ko añakuágui?
(¿No podemos escabullirnos por la selva para salir de esta fosa?.)"],
		["Dionisio", "Peligróso upéa, oje'e Alfredo okañy akokuehe ha ojetopa hete Parana rembe'ýre.
(Eso es peligroso, dicen que Alfredo se escapo anteayer y encontraron su cuerpo a orillas del río Paraná.)"],
		["Dionisio", "Ag̃aite atopáta la forma ñasẽ ko'águi.
(Pronto voy a encontrar como salir de acá)"]
],
}

func _ready() -> void:
	fondo_carat.hide()
	transi.play("salida")
	time.start()
	cine.play("dio va")
	await time.timeout
	dio.oho = true
	await cine.animation_finished
	dio.oho=false
	camara.position = $posi_camara.position
	inicia_dialoga("conversa")
	DialogSystem.dialogo_opa.connect(dialog_terminado)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$cosa/Ulise/corpu2/pecho/AnimationPlayer.play("okemano")
	$cosa/Rogelio/AnimationPlayer.play("okemano")
	
	
	$marta/blockbench_export/AnimationPlayer.play("arregla")
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()
	if fino:
		if Input.is_action_just_pressed("interaccion"):
			get_tree().change_scene_to_file("res://escenarios/nivel3/cinematucas/mama.tscn")

func inic_dialo() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		return
	dialogo_activo = true
	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])

func dialog_terminado() -> void:
	dialogo_activo = false
	if npc_actual == "conversa":
		transi.play("entrafa")
		fondo_carat.show()
		carto.play("desliza")
		await  carto.animation_finished
		anima_boton.play("aparicion")
		await anima_boton.animation_finished
		anima_qr.play("aparece")
		
		fino = true
		return
func inicia_dialoga(id_npc: String) -> void:
	npc_actual = id_npc
	inic_dialo()
	
	
