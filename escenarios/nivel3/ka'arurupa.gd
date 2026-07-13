extends Node

var posicion1 : Vector3
var posicion2 : Vector3

@onready var jugador =$dionisio
@onready var control_camara = $dionisio/pivote
@onready var anima_jugon = $dionisio/blockbench_export/AnimationPlayer

@onready var tri_fr = $objetos/casa1/trigger_farra
@onready var puntos_spawn: Node =$"posible aparecer ka'arurupa"
@onready var kaarurupa: Resource = preload("res://escenarios/nivel3/ka'arurupa.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawn_yuyo()


func spawn_yuyo():
	var instancia_yuyo: Node3D = kaarurupa.instantiate()
	add_child(instancia_yuyo)

	var marcadores: Array[Marker3D] = []

	for hijo in puntos_spawn.get_children():
		if hijo is Marker3D:
			marcadores.append(hijo)

	if marcadores.is_empty():
		push_error("No hay Marker3D para hacer spawn.")
		return

	var marcador : Marker3D = marcadores.pick_random()
	instancia_yuyo.global_position = marcador.global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#func obtiene_posicion(p1: Vector3, p2:Vector3) -> Vector3:
	#var min_x = min(p1.x, p2.x)
	#var max_x = max(p1.x, p2.x)

	#var min_z = min(p1.z, p2.z)
	#var max_z = max(p1.z, p2.z)

	#var x = randf_range(min_x, max_x)
	#var z = randf_range(min_z, max_z)

	#return Vector3(x , 1.2, z)
	
#unc spawn_yuyo():
	#var instancia_yuyo: Node3D = kaarurupa.instantiate()
	#add_child(instancia_yuyo)
	#var spawn_location: Vector3 = obtiene_posicion(posicion1, posicion2)
	#instancia_yuyo.position =spawn_location
	#print("aparecio")
	


func _on_trigger_farra_body_entered(body: Node3D) -> void:
	if body.is_in_group("jugador_global") or body.is_in_group("jugon"):
		tri_fr.queue_free()
		control_camara.posiciona()
		jugador.puede_moverse = false
		control_camara.farra = true
		anima_jugon.play("repiraomañavo")
		await anima_jugon.animation_finished
		anima_jugon.play("repiraomañavo")
		await anima_jugon.play("repiraomañavo")
		anima_jugon.play("oho")
		
