extends Node3D

@onready var interac: Label=$Control/Label
@onready var npc=$npc/Area3D


func _ready() -> void:
	interac.hide()
	npc.corpus_entro.connect(mostrar_interac)
	npc.corpus_salio.connect(hide_interac)
	
func mostrar_interac():
	interac.show()
	if Input.is_action_just_pressed("interaccion"):
		print("Boton presionado")

func hide_interac():
	interac.hide()
	
