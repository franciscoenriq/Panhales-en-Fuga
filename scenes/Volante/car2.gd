extends CharacterBody3D

@export var sensitivity = 1000
@onready var pivoteCamera := $pivoteCamera
@onready var camera := $pivoteCamera/Camera3D
var isTurningLeft: bool
var isTurningRight: bool
@onready var volante=%MeshInstance3D
var turningRate: float = 5.0  # Aumenta la velocidad de giro
var forceFeedback: float = 3.0
var maxWheelAngle: float = 90.0
var wheelRotationValue: float

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivoteCamera.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))



func _ready() -> void:
	isTurningLeft = false
	isTurningRight = false
	wheelRotationValue = 0

func _physics_process(delta: float) -> void:
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
	GameController.turn.rpc("Driver", -wheelRotationValue)
	
	#Ahora debemos girar al auto hacia la derecha o izquierda segun corresponda mediante el volante.
	var turn = -wheelRotationValue
	if turn:
		velocity.x = turn*GameController.velocidad_lateral
	else:
		velocity.x = move_toward(velocity.x,0,GameController.velocidad_lateral)

	#print(global_position)
	move_and_slide()
	
	
	var collision = get_last_slide_collision()
	if collision :
		print("collided with ",collision.get_collider())
		get_tree().quit()

