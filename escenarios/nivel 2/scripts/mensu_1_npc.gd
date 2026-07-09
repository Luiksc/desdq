extends CharacterBody3D


@onready var sako:=$blockbench_export/sako
@onready var animacion = $blockbench_export/AnimationPlayer

@export var waypoint :Array[Marker3D]
@export var jevyrenda : Array[Marker3D] 

var indice_ida = 0
var indice_vuelta
var gravedad := 100

var velocidad :float = 6

enum estado{
	oraha,
	ojevy,
	opytu,
}
var Estado = estado
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sako.hide()
	Estado = estado.oraha
	



func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta
		velocity.y = max(velocity.y, -gravedad * 3)
	match Estado:
		estado.oraha:
			sako.show()
			animacion.play("oraha")
			indice_vuelta = 0
			var distancia_minima := 1
			var posicion_target = waypoint[indice_ida].global_position
			var direccion = posicion_target - global_position
			var distancia = direccion.length()
			var punto_mira = Vector3(posicion_target.x, global_position.y, posicion_target.z)
			# Verificamos que no estemos exactamente encima del punto para evitar errores de cálculo
			if global_position.distance_to(punto_mira) > 0.1:
				look_at(punto_mira, Vector3.UP)
			
			direccion = direccion.normalized()
			velocity.x = direccion.x * velocidad
			velocity.z = direccion.z * velocidad
			
			if distancia < distancia_minima:
				indice_ida = indice_ida +1
				if indice_ida >= waypoint.size():
					Estado = estado.ojevy
			
		
			
			


		estado.ojevy:
			sako.hide()
			animacion.play("ojevy")
			var distancia_minima := 1
			var posicion_target = waypoint[indice_vuelta].global_position
			var direccion = posicion_target - global_position
			var distancia = direccion.length()
			var punto_mira = Vector3(posicion_target.x, global_position.y, posicion_target.z)
			if global_position.distance_to(punto_mira) > 0.1:
				look_at(punto_mira, Vector3.UP)
			direccion = direccion.normalized()
			velocity.x = direccion.x * velocidad
			velocity.z = direccion.z * velocidad
			
			if distancia < distancia_minima:
				indice_vuelta = indice_vuelta + 1
				if indice_vuelta >= jevyrenda.size():
					indice_ida = 0
					
					Estado = estado.oraha
			
	move_and_slide()
			
