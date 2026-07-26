extends Node3D



var dialog_activo: bool = false
var npc_actual: String = ""
var pensamiento_activo: bool = false  
var dialogos ={
	"Mami":[
		["Karãu Sy","Che memby, ndereipe'ái ra'e nde fárra ao.
(No te sacaste aún tu ropa de farra)"],
		["Karãu Sy", "Chekangy ko che memby
(Estoy débil mi niño)"],
		["Karãu Sy", "Ehomína eheka pohã ñana che pohãpe g̃uarã, ame'ẽta ndéve peteĩ kuatia'ipe la pohãnguéra.
(Anda por favor busca unos yuyos para mi remedio, Voy a darte una lista con los remedios.)"],
]
}
func _ready() -> void:
	DialogSystem.dialogo_opa.connect(dialog_terminado)
	$"Control/ã/AnimationPlayer".play("salida")
	await $"Control/ã/AnimationPlayer".animation_finished 
	asigna_clave("Mami")
func _process(delta: float) -> void:
	$mama/AnimationPlayer.play("repira")
	if dialog_activo:
		
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
			$DialogSystem/sound.play()

func inic_dialog() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		return
	
	dialog_activo = true


	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])

func dialog_terminado() -> void:
	dialog_activo = false
	if npc_actual == "Mami":
		$"Control/ã/AnimationPlayer".play("entrafa")
		await $"Control/ã/AnimationPlayer".animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel3/nivel_3.tscn")
	
func asigna_clave(id_del_npc: String) -> void:
	npc_actual = id_del_npc
	inic_dialog()
