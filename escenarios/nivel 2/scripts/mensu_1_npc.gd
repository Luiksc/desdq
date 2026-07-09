extends CharacterBody3D


@onready var sako:=$blockbench_export/sako
@onready var animacion = $blockbench_export/AnimationPlayer

@export var waypoint :Array[Marker3D]
@export var jevyrenda : Array[Marker3D] 

var indice_ida = 0
var indice_vuelta =0
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
	



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta
		velocity.y = max(velocity.y, -gravedad * 3)
	match Estado:
		estado.oraha:
			sako.show()
			animacion.play("oraha")
			indice_vuelta = 0
			var distancia_minima := 0.15
			
			var posicion_target = waypoint[indice_ida].global_position
			var direccion = posicion_target - global_position
			direccion.y =0
			var distancia = direccion.length()
			var angulo = atan2(direccion.x,direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo, 2 * delta)
			
			direccion = direccion.normalized()
			
			var diferencia = abs(angle_difference(rotation.y, angulo))
	
			if diferencia < 0.15:
				if animacion.current_animation != "oraha":
					animacion.play("oraha")
					
				velocity.x = direccion.x * velocidad
				velocity.z = direccion.z * velocidad
			else:
				velocity.x = move_toward(velocity.x, 1, velocidad * delta)
				velocity.z = move_toward(velocity.z, 1, velocidad * delta)
			
			if distancia < distancia_minima:
				
				indice_ida = indice_ida +1
				if indice_ida >= waypoint.size():
					Estado = estado.ojevy
			
		
			
			


		estado.ojevy:
		
			var distancia_minima := 1
			var posicion_target = waypoint[indice_vuelta].global_position
			var direccion = posicion_target - global_position
			var distancia = direccion.length()
			var angulo = atan2(direccion.x,direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo, 2 * delta)
			sako.hide()
			
			direccion = direccion.normalized()
			
			
			var diferencia = abs(angle_difference(rotation.y, angulo))
	
			if diferencia < 0.15:
				if animacion.current_animation != "ojevy":
					animacion.play("ojevy")
					
				velocity.x = direccion.x * velocidad
				velocity.z = direccion.z * velocidad
			else:
				velocity.x = move_toward(velocity.x, 1, velocidad * delta)
				velocity.z = move_toward(velocity.z, 1, velocidad * delta)
			
			
			if distancia < distancia_minima:
				indice_vuelta = indice_vuelta + 1
				if indice_vuelta >= jevyrenda.size():
					indice_ida = 0
					
					Estado = estado.oraha
			
	move_and_slide()
			
