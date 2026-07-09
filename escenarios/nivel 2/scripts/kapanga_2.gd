extends CharacterBody3D

#@onready var sako:=$blockbench_export/sako
@onready var animacion = $blockbench_export/AnimationPlayer




@export var ohota : Array[Marker3D]

var jugador 
var indice_ida = 0
var indice_vuelta=0
var gravedad := 100
var detectado :bool = false

var velocidad :float = 6


enum estado{
	oho,
	oinopa,
	omuña,
}
var Estado = estado
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animacion.animation_finished.connect(animacion_termino)
	Estado = estado.oho
	



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta
		velocity.y = max(velocity.y, -gravedad * 3)
	match Estado:
		estado.oho:
			if animacion.current_animation != "camina":
				animacion.play("camina")
			var distancia_minima := 0.1
			
			var posicion_target = ohota[indice_ida].global_position
			var direccion = posicion_target - global_position
			direccion.y=0
			var angulo = atan2(direccion.x,direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo, 2 * delta)
			var distancia = direccion.length()
			direccion = direccion.normalized()
			
			var diferencia = abs(angle_difference(rotation.y, angulo))
	
			if diferencia < 0.15:
				if animacion.current_animation != "camina":
					animacion.play("camina")
					
				velocity.x = direccion.x * velocidad
				velocity.z = direccion.z * velocidad
			else:
				if animacion.current_animation != "repira":
					animacion.play("repira")
				velocity.x = move_toward(velocity.x, 0.0, velocidad * delta)
				velocity.z = move_toward(velocity.z, 0.0, velocidad * delta)
			
			if distancia < distancia_minima:
				velocity.x = 0
				velocity.z=0
				indice_ida = indice_ida +1
				if indice_ida >= ohota.size():
					indice_ida =0
			if detectado:
				Estado = estado.omuña
				
					
		estado.omuña:
			if jugador == null:
				velocity = Vector3.ZERO
				return
			
			var direccion = jugador.global_position - global_position
			direccion.y = 0
			var target = jugador.global_position
			var punto_mira = Vector3(target.x, global_position.y, -target.z) 
			if global_position.distance_to(punto_mira) > 0.1: 
				look_at(punto_mira, Vector3.UP)
			direccion = direccion.normalized()
			velocity = direccion * velocidad
			move_and_slide()
					
					
					
		estado.oinopa:
			if velocity.x == 0 and velocity.z == 0:
				if animacion.current_animation != "oinupa":
					animacion.play("oinupa")
				
	move_and_slide()
func animacion_termino(nombre):
	if nombre == "oinupa":
		indice_ida +=1
		if indice_ida >= ohota.size():
			indice_ida=0
		Estado = estado.oho
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	detectado=true
	var nivel := get_tree().current_scene
	if nivel != null:
		jugador = nivel.get_node_or_null("jugador")
