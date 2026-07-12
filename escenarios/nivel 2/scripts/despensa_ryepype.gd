extends Node3D

@onready var anima =$"Control/ã/AnimationPlayer"
@onready var compra = $Control/compra
@onready var debe = $Control/deber
@onready var ahorro = $Control/Label
@onready var anima_insufi = $Control/comprr/AnimationPlayer
@onready var insuficiente= $Control/comprr

var dialogo_activo: bool = false

var npc_actual: String = ""
var pensamiento_activo: bool = false  # true mientras el diálogo de pensamiento está corriendo
var dialogos ={
	"despensa":[
		["Dionisio", "Buenas noches, voy a querer harina de trigo y poroto.
¿Cuánto sale?"],
		["Almacenero","La harina esta 27 y el poroto a 22"],
		["Dionisio","(Ndiiij, adebe jeýtante ko semana pe g̃uarã)
		Ndaipóripa la ibaratovéva"],
		["Almacenero", "Ha terehóna eporeka algo ka'aguy apytépe mba'e"]
		
		
],
	"Comprado":[
		["Dionisio", "Voy a deberte, mensualidad piko mboýpa ou ko mes"],
		["Almacenero", "Dionisio Báez.
		*Paga del mes, 150 guaraies
		*Deuda de uniforme -18 guaraníes.
		*Compra de machete que usted rompió -70 guaranies
		*Fiado de alimentos del me pasado -55
		Saldo de 7 guaranies"],
		["Dionisio", "¡No puede ser!"],
		["Almacenero", "Aún le queda
		*Deuda de trasporte hasta acá:
		400 guaraníes cada persona,
		800 usted y su esposa.
		*Deuda de uso de herramientas.
		*Y la vez que no trabajo por estar 'enfermo'. -150 guaranies "],
		["Dionisio", "El hombre que nos contrato no nos aviso de ninguna de estos gastos"],
		["Dionisio", "Chakeko he'ivoíkuri traslado gratuido"],
		["ALmacenero", "A mí que me importa lo que dijo un hombre hace un mes, lo que está en el documento, se cumple"]
		
	],
	
}

func _ready() -> void:
	insuficiente.hide()
	anima.play("salida")
	await  anima.animation_finished
	$Node3D.inicial.connect(conversa)
	conversa("despensa")


	DialogSystem.dialogo_opa.connect(dialog_terminado)

func conversa(id_del_npc: String):
	npc_actual = id_del_npc
	inic_dialo()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if dialogo_activo:
		# E funciona como "next" mientras el diálogo está ocurriendo
		if Input.is_action_just_pressed("interaccion"):
			
			DialogSystem.neixt()
			$DialogSystem/sound.play()
			
			
	
		# E inicia el diálogo si el jugador está en el área y no hay diálogo activo
		

# Recibe el npc_id emitido por la señal corpus_entro del trigger

func inic_dialo() -> void:
	if npc_actual=="":
		return
	if not dialogos.has(npc_actual):
		return
	
	
	dialogo_activo = true

	for linea in dialogos[npc_actual]:
		DialogSystem.says(linea[1], linea[0])
	 # bloquea el movimiento del jugador
	#DialogSystem.says("¿No te entera
	# Se llama mediante señal cuando el DialogSystem termina todos los mensajes
func dialog_terminado() -> void:
	dialogo_activo = false
	if npc_actual == "despensa":
		compra.show()
		debe.show()
	if npc_actual == "Comprado":
		ahorro.text = "ahorros:
19 Guaraníes"
		anima.play("entrafa")
		await anima.animation_finished
		get_tree().change_scene_to_file("res://escenarios/nivel 2/cinematicas/cinamatica_n_2.tscn")
  # desbloquea el movimiento

	# Si era un pensamiento de Delfina, destruimos el trigger y listo


	# Si el jugador todavía está en el área de un NPC, volvemos a mostrar el label


func _on_deber_pressed() -> void:
	var npc_id: String ="Comprado"
	npc_actual = npc_id
	inic_dialo()


func _on_compra_pressed() -> void:
	insuficiente.show()
	anima_insufi.play("mostra")
	await anima_insufi.animation_finished
	insuficiente.hide()
