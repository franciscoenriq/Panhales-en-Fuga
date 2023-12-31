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
@onready var vel_text = $pivoteCamera/Control/Vel
@onready var bra_text= $pivoteCamera/Control/BRA
@onready var clu_text = $pivoteCamera/Control/CLU
@onready var gas_text = $pivoteCamera/Control/GAS
@onready var gear_text= $pivoteCamera/Control/GEAR
#var puntaje = 0



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
	#puntaje+=int(delta*100)
	#GameController.distance_traveled=puntaje
	var bra_pressure = GameController.get_bra_pressure()
	var clu_pressure = GameController.get_clutch_pressure()
	var gas_pressure = GameController.get_gas_pressure()
	var gear = GameController.get_gear()
	var spd = GameController.car_speed
	
	
	bra_text.text = "BRA : " + bra_pressure
	clu_text.text = "CLU : " + clu_pressure
	gas_text.text = "GAS : " + gas_pressure
	gear_text.text = "GEAR: " + gear
	vel_text.text = "SPD: " + str(spd)
	
	
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
	GameController.current_turn = turn
	
	if GameController.current_turn:
		velocity.x = turn*GameController.velocidad_lateral
	else:
		velocity.x = move_toward(velocity.x,0,GameController.velocidad_lateral)

	#print(global_position)
	
	move_and_slide()
	
	
