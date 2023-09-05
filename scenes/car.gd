extends VehicleBody3D

var isTurningLeft: bool
var isTurningRight: bool
@onready var volante=%MeshInstance3D
var turningRate: float = 5.0  # Aumenta la velocidad de giro
var forceFeedback: float = 3.0
var maxWheelAngle: float = 90.0
var wheelRotationValue: float

func _ready() -> void:
	isTurningLeft = false
	isTurningRight = false
	wheelRotationValue = 0

func _process(delta: float) -> void:
	if Input.is_action_pressed("turn_left"):
		isTurningLeft = true
		isTurningRight = false
	elif Input.is_action_pressed("turn_right"):
		isTurningRight = true
		isTurningLeft = false
	else:
		isTurningLeft = false
		isTurningRight = false

	if isTurningLeft:
		wheelRotationValue = clamp(wheelRotationValue + turningRate * delta, -1.0, 1.0)
	elif isTurningRight:
		wheelRotationValue = clamp(wheelRotationValue - turningRate * delta, -1.0, 1.0)
	else:
		wheelRotationValue = lerp(wheelRotationValue, 0.0, forceFeedback * delta)

	# Limita el ángulo del volante al rango deseado
	wheelRotationValue = clamp(wheelRotationValue, -1.0, 1.0)

	# Aplicar la rotación al volante
	var rotation_angle = maxWheelAngle * wheelRotationValue
	volante.rotation_degrees.y = rotation_angle
	GameController.turn(name, wheelRotationValue)
