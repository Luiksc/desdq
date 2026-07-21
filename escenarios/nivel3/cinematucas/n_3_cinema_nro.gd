extends Node3D

@onready var transicion = $Control/ColorRect/AnimationPlayer
@onready var anima_kuñatai= $"kuñatai/AnimationPlayer"
@onready var kuñatai = $"kuñatai"
@onready var karau = $karau
@onready var ambos = $ojeroky
@onready var anima_ojeroky = $ojeroky/AnimationPlayer
@onready var fondo =$WorldEnvironment
@onready var nuevo_fonde = preload("res://background/yvaga sky pytumba.png")
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
	$DirectionalLight3D.light_color= Color(0.813, 0.381, 0.527)
	anima_ojeroky.play("repira")
	ambos.hide()
	
	anima_kuñatai.play("sentada")
	await anima_kuñatai.animation_finished
	anima_kuñatai.play("sentada")
	await anima_kuñatai.animation_finished
	anima_kuñatai.play("sentada")
	await anima_kuñatai.animation_finished
	anima_kuñatai.play("sentada")
	await anima_kuñatai.animation_finished
	$Timer.start()
	anima_kuñatai.play("ñemboy")
	await $Timer.timeout
	$"kuñatai/AnimationPlayer2".play("oho")
	await anima_kuñatai.animation_finished
	transicion.play("aparece")
	await transicion.animation_finished
	kuñatai.hide()
	karau.hide()
	ambos.show()
	transicion.play("desaparece")
	await transicion.animation_finished
	anima_ojeroky.play("oñemoi")
	await anima_ojeroky.animation_finished
	transicion.play("aparece")
	await transicion.animation_finished
	$DirectionalLight3D.light_color= Color(0.269, 0.316, 0.791)
	fondo.environment.sky.sky_material.panorama = nuevo_fonde
	ambos.position = $punto.position
	camara.position = destino1_camara.position
	transicion.play("desaparece")
	await transicion.animation_finished
	anima_ojeroky.play_backwards("oñemoi")
	var anim_player_iru = $iru/blockbench_export/AnimationPlayer
	anim_player_iru.get_animation("oho").loop_mode = Animation.LOOP_LINEAR
	anim_player_iru.get_animation("repira").loop_mode = Animation.LOOP_LINEAR
	
	anim_player_iru.play("oho")
	var tween = create_tween()
	tween.tween_property($iru, "global_position", $final.global_position, 2.5)
	await tween.finished
	anim_player_iru.play("repira")
	asigna_id("noticia")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$karau/AnimationPlayer.play("repira")
	if dialogo_activo:
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()

func asigna_id(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialo()
	if id_del_npc == "noticia":
		await get_tree().create_timer(40.0).timeout
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
		anima_ojeroky.play("oñemoi")
		await anima_ojeroky.animation_finished
		transicion.play("aparece")
		await transicion.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel3/cinematucas/n3_cinema-nro2.tscn")
		
	return

	
