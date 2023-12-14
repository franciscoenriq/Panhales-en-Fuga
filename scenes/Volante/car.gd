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


func _ready() -> void:
	isTurningLeft = false
	isTurningRight = false
	wheelRotationValue = 0

func _physics_process(delta: float) -> void:


	
	#Ahora debemos girar al auto hacia la derecha o izquierda segun corresponda mediante el volante.
	var turn = GameController.current_turn
	if turn:
		velocity.x = turn*GameController.velocidad_lateral
	else:

		velocity.x = move_toward(velocity.x,0,GameController.velocidad_lateral)

	#print(global_position)
	
	move_and_slide()


