extends Node3D

@onready var interac: Label=$Control/Label
@onready var npc=$npc/Area3D

var jugador_puede_interac:bool = false
var dialogo_activo := false


func _ready() -> void:
	interac.hide()
	npc.corpus_entro.connect(mostrar_interac)
	npc.corpus_salio.connect(hide_interac)
	DialogSystem.dialogo_opa.connect(dialog_terminado)


func _process(delta: float) -> void:
	if jugador_puede_interac and Input.is_action_just_pressed("interaccion"):
		print("yes")
	if DialogSystem.estar_mostrando():
		 DialogSystem.neixt()
	else:
		inic_dialo()

func inic_dialo():
	interac.hide()
	DialogSystem.says("afsdasfadfdd", "sa")
	DialogSystem.says("mi boooooombo", "sa")
	endialogo = true

func dialog_terminado():
	dialogo_activo=false
	if jugador_puede_interac:
		interac.show()
	
func fin_dialo():
	DialogSystem._on_next_button_pressed()
	endialogo =false
	
	
func mostrar_interac():
	interac.show()
	jugador_puede_interac=true
	

func hide_interac():
	interac.hide()
	jugador_puede_interac=false
	
	
