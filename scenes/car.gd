extends VehicleBody3D

var isTurningLeft 
var isTurningRight 
@onready var volante = %MeshInstance3D
var turningRate = 0.2
var forceFeedback = 0.1
var wheelRotationValue

func _ready() -> void:
	isTurningLeft = false
	isTurningRight = false
	wheelRotationValue = 0
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
	
	if not isTurningLeft && not isTurningRight && wheelRotationValue!=0:
		if wheelRotationValue>0:
			wheelRotationValue-=forceFeedback
		if wheelRotationValue<0:
			wheelRotationValue+=forceFeedback
		
	if isTurningLeft && wheelRotationValue -turningRate >-1.0001:
		wheelRotationValue-=turningRate
		
	if isTurningRight && wheelRotationValue + turningRate<1.0001:
		wheelRotationValue+=turningRate
		
	GameController.turn(name,wheelRotationValue)
	
	
	
	
	
	
