extends Node3D

@onready var interac: Label=$Control/Label
@onready var npc=$npc/Area3D

var jugador_puede_interac:bool = false
var endialogo:= false


func _ready() -> void:
	interac.hide()
	npc.corpus_entro.connect(mostrar_interac)
	npc.corpus_salio.connect(hide_interac)

func _process(delta: float) -> void:
	if jugador_puede_interac and Input.is_action_just_pressed("interaccion"):
		if not endialogo:
			endialogo=true
			DialogSystem.says("afsdasfadfdd", "sa")
			DialogSystem.says("mi boooooombo", "sa")
		if endialogo:
			DialogSystem._on_next_button_pressed()
			
func mostrar_interac():
	interac.show()
	jugador_puede_interac=true
	

func hide_interac():
	interac.hide()

	
	
