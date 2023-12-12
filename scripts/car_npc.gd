extends Node

var isSwitchingLane = false
var current_lane_pos
var target_lane_pos

var average_speed = 10
var change_lane_speed=10*1.4


var isPolice
var pista_id
var isMoving = true

# Called when the node enters the scene tree for the first time.
func _ready():

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isSwitchingLane==true:
		#Queremos movernos desde la posicion actual hasta la objetivo. El cambio será solo en el eje x
		var target_position = self.global_transform
		target_position.origin.x=target_lane_pos.x
		self.global_transform.origin = self.global_transform.origin.lerp(
			target_position.origin,delta)
		if (self.global_transform.origin.x-target_position.origin.x)<abs(0.01):
			isSwitchingLane=false
			print("se terminó de cambiar de carril")
	var npc_speed
	var objetivo
	var new_position

	if pista_id>0:
		npc_speed= GameController.car_speed-randf_range(-0.3, 1.3) * average_speed * 5
		objetivo = -Vector3(0, 0, npc_speed * delta)
	else:
		npc_speed= -GameController.car_speed-randf_range(-0.3, 1.3) * average_speed * 5
		objetivo = Vector3(0, 0, npc_speed * delta)
	
	
	new_position = self.global_transform.origin.lerp(
		self.global_transform.origin + objetivo,
		delta*npc_speed 
	)
	self.global_transform.origin = new_position
	

func get_isSwitchingLane():
	return isSwitchingLane
		
func set_isSwitchingLane(value:bool):
	isSwitchingLane = value
	
func set_isPolice(value:bool):
	isPolice=value
	
func get_isPolice():
	return isPolice
	
func set_pistaid(value):
	pista_id = value
func get_pistaid():
	return pista_id

func set_current_lane_pos(value):
	current_lane_pos=value
func set_target_lane_pos(value):
	target_lane_pos=value

