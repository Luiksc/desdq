extends CharacterBody3D


@onready var sako:=$blockbench_export/sako
@onready var animacion = $blockbench_export/AnimationPlayer

@export var outa :Marker3D
@export var ohota : Marker3D

var indice_ida = 0
var indice_vuelta=0
var gravedad := 100

var velocidad :float = 6

enum estado{
	ou,
	oho,
	opytu,
}
var Estado = estado
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sako.hide()
	Estado = estado.ou
	



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta
		velocity.y = max(velocity.y, -gravedad * 3)
	match Estado:
		estado.ou:
			
			
			var distancia_minima := 1
			var posicion_target = outa.global_position
			var direccion = posicion_target - global_position
			var angulo = atan2(direccion.x,-direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo, 2 * delta)
			var distancia = direccion.length()
			direccion = direccion.normalized()
			var diferencia = abs(angle_difference(rotation.y, angulo))
			sako.show()
			if animacion.current_animation != "oraha":
				animacion.play("oraha")
			if diferencia < 0.15:
			
					
				velocity.x = direccion.x * velocidad
				velocity.z = direccion.z * velocidad
			else:
				velocity.x = move_toward(velocity.x, 1, velocidad * delta)
				velocity.z = move_toward(velocity.z, 1, velocidad * delta)
			
			if distancia < distancia_minima:
					Estado = estado.oho
			
		
			
			


		estado.oho:
			sako.hide()
			if animacion.current_animation != "ojevy":
					animacion.play("ojevy")
			var distancia_minima := 1
			var posicion_target = ohota.global_position
			var direccion = posicion_target - global_position
			var distancia = direccion.length()
			var angulo = atan2(direccion.x,-direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo, 2 * delta)
			direccion = direccion.normalized()
			
			var diferencia = abs(angle_difference(rotation.y, angulo))
	
			if diferencia < 0.15:
				
					
				velocity.x = direccion.x * velocidad
				velocity.z = direccion.z * velocidad
			else:
				velocity.x = move_toward(velocity.x, 1, velocidad * delta)
				velocity.z = move_toward(velocity.z, 1, velocidad * delta)
			if animacion.current_animation != "ojevy":
				animacion.play("ojevy")
			
			if distancia < distancia_minima:
			
					Estado = estado.ou
			
	move_and_slide()
			
