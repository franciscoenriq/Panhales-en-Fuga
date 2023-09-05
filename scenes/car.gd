extends VehicleBody3D

var isTurningLeft 
var isTurningRight 
@onready var volante = %Volante
var turningRate = 0.3

func _ready() -> void:
	isTurningLeft = false
	isTurningRight = false

func _process(delta):
	
	if Input.is_action_pressed("turn_left"):
		isTurningLeft = true
		isTurningRight = false
	elif Input.is_action_pressed("turn_right"):
		isTurningRight = true
		isTurningLeft = false
	else:
		isTurningLeft = false
		isTurningRight = false
	
	if not isTurningLeft && not isTurningRight:
		pass
		
