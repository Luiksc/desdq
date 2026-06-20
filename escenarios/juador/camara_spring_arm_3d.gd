extends SpringArm3D

@export var sensi := 0.004
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensi
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * sensi
		rotation.x = clamp(rotation.x, -PI/2, PI/4)

		#la funcion clamp hace que se limiten ciertos valores
	
 
