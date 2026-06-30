extends Node3D

@onready var interac: Label = $Control/Label
@onready var npc = $npc/Area3D
@onready var jugador = $jugador  # referencia al nodo del jugador

var jugador_puede_interac: bool = false
var dialogo_activo: bool = false


func _ready() -> void:
	interac.hide()
	npc.corpus_entro.connect(mostrar_interac)
	npc.corpus_salio.connect(hide_interac)
	DialogSystem.dialogo_opa.connect(dialog_terminado)


func _process(delta: float) -> void:
	if dialogo_activo:
		# E funciona como "next" mientras el diálogo está ocurriendo
		if Input.is_action_just_pressed("interaccion"):
			DialogSystem.neixt()
	elif jugador_puede_interac:
		# E inicia el diálogo si el jugador está en el área y no hay diálogo activo
		if Input.is_action_just_pressed("interaccion"):
			inic_dialo()


func inic_dialo() -> void:
	dialogo_activo = true
	interac.hide()
	jugador.puede_moverse = false  # bloquea el movimiento del jugador
	DialogSystem.says("¿No te enteraste de la fiesta que hizo la fábrica por el Día de la Raza ? Todos están ahí; seguramente Mateo también.", "Ña Clotilde")



# se llama mendiante señal cuando el dialogsystem termina todos los mensajes
func dialog_terminado() -> void:
	dialogo_activo = false
	jugador.puede_moverse = true  # desbloquea el movimiento
	# Si el jugador todavía está en el área, volvemos a mostrar el label de interacción
	if jugador_puede_interac:
		interac.show()


# El jugador entra al área del NPC
func mostrar_interac() -> void:
	interac.show()
	jugador_puede_interac = true


# El jugador sale del área del NPC
func hide_interac() -> void:
	interac.hide()
	jugador_puede_interac = false
	# Si se va mientras hay un diálogo activo, reseteamos y desbloqueamos
	if dialogo_activo:
		dialogo_activo = false
		jugador.puede_moverse = true
