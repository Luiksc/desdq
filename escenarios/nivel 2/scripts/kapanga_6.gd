extends CharacterBody3D

#@onready var sako:=$blockbench_export/sako
@onready var animacion = $blockbench_export/AnimationPlayer
@onready var sond_sorpresa = $Exclamacion
@onready var sorpresa = $sorpresa
@onready var timer = $Timer
@onready var timer_omuña = $Timer2
@onready var llaves := $AudioStreamPlayer3D

@export var ohota : Array[Marker3D]

var jugador 
var indice_ida = 0
var indice_vuelta=0
var gravedad := 100
var detectado :bool = false

var velocidad :float = 10


enum estado{
	oho,
	oinopa,
	omuña,
}
var Estado = estado
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sorpresa.hide()
	animacion.animation_finished.connect(animacion_termino)
	Estado = estado.oho
	timer_omuña.wait_time = 4.0
	timer_omuña.one_shot = true
	if not timer_omuña.timeout.is_connected(_on_timer_omuña_timeout):
		timer_omuña.timeout.connect(_on_timer_omuña_timeout)
	llaves.play()



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta
		velocity.y = max(velocity.y, -gravedad * 3)
	match Estado:
		estado.oho:
			if animacion.current_animation != "camina":
				animacion.play("camina")
			var distancia_minima := 1
			
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
				
				
		estado.omuña:
			if animacion.current_animation != "camina":
				animacion.play("camina")
			if jugador == null:
				velocity = Vector3.ZERO
				return
			
			var direccion = jugador.global_position - global_position
			direccion.y = 0
			if not is_on_floor():
				velocity.y -= gravedad * delta
				velocity.y = max(velocity.y, -gravedad * 3)
			var target = jugador.global_position
			var angulo = atan2(direccion.x,direccion.z)
			rotation.y = lerp_angle(rotation.y, angulo, 5 * delta)
			direccion = direccion.normalized()
			velocity = direccion*velocidad
			
				
				
				
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
	if not (body.is_in_group("jugon") or body.is_in_group("jugador_global")):
		return
	detectado = true
	sond_sorpresa.play()
	sorpresa.show()
	timer.start()
	
	# Obtener referencia al jugador
	var nivel := get_tree().current_scene
	if nivel != null:
		jugador = nivel.get_node_or_null("jugador")
	if jugador == null:
		jugador = body
	
	# Entrar en omuña y (re)iniciar el timer de 4 segundos
	Estado = estado.omuña
	timer_omuña.stop()
	timer_omuña.start()


func _on_timer_timeout() -> void:
	sorpresa.hide()


func _on_timer_omuña_timeout() -> void:
	# Pasaron 4 segundos: volver a patrullar
	detectado = false
	jugador = null
	Estado = estado.oho
