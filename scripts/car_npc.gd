extends Node

var isSwitchingLane = false
var current_lane_pos
var target_lane_pos
@onready var player = $car2
var average_speed = 10
var change_lane_speed=10*1.4
var tolerancia = 5
var police_speed
var target_lane_id=0
var isCarNearby=false
var isPolice
var pista_id
var isMoving = true
signal car_nearby
var deteccion:Area3D
var area_derrota:Area3D
var auto:MeshInstance3D
@onready var lane = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	deteccion = $deteccion
	deteccion.area_entered.connect(self._on_area_entered)
	deteccion.area_exited.connect(self._on_area_exited)
	auto = getMeshInstance()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var npc_speed
	var objetivo
	var new_position

	if isSwitchingLane==true && target_lane_id !=0:

		#Queremos movernos desde la posicion actual hasta la objetivo. El cambio será solo en el eje x
		var target_position = self.global_transform
		target_position.origin.x=target_lane_pos.x
		if not isPolice:
			
			self.global_transform.origin = self.global_transform.origin.lerp(
				target_position.origin,delta*5)
		else:
			self.global_transform.origin = self.global_transform.origin.lerp(
				target_position.origin,delta*10)
			
		if (self.global_transform.origin.x-target_position.origin.x)<abs(0.1) && isPolice==true:
			isSwitchingLane=false
			pista_id=target_lane_id
			target_lane_id=0

		


	if not isPolice : #Si no es policia, se mueve de forma normal
		if pista_id>0:
			#velocidad relativa 
			npc_speed= GameController.car_speed-randf_range(-0.5, 1.5) * average_speed * 5	
			objetivo = -Vector3(0, 0, npc_speed * delta)
			
		else:
			#velocidad relativa
			npc_speed= -GameController.car_speed-randf_range(-0.3, 1.3) * average_speed * 5

			objetivo = Vector3(0, 0, npc_speed * delta)
		
	if isPolice:
		#la policia debe perseguir al player. Para ello, su velocidad será mayor hasta alcanzar 
		#al jugador.		
		#El policía quiere alcanzar la posicion en z del player. Para ello, quiere alcanzar la posicion 
		#
		npc_speed= GameController.car_speed-randf_range(-0.3, 1.3) * average_speed * 7
		objetivo = -Vector3(0, 0, npc_speed*delta)
	
	
		
	if isCarNearby && isSwitchingLane==false:
		npc_speed=npc_speed*0.8

		#Hay un auto en frente. Debemos cambiar de pista el auto.
		if pista_id==1:
			isSwitchingLane=true
			target_lane_id=2
			target_lane_pos=lane.get_target_lane_pos(target_lane_id)

		if pista_id==2:
			isSwitchingLane=true
			target_lane_id=1
			target_lane_pos=lane.get_target_lane_pos(target_lane_id)

		if pista_id==-1:
			isSwitchingLane=true
			target_lane_id=-2
			target_lane_pos=lane.get_target_lane_pos(target_lane_id)

		if pista_id==-2:
			isSwitchingLane=true
			target_lane_id=-1
			target_lane_pos=lane.get_target_lane_pos(target_lane_id)


	
	
		
	new_position = self.global_transform.origin.lerp(
		self.global_transform.origin + objetivo,
		delta*npc_speed
	)	
		
	self.global_transform.origin = new_position




#GETTERS Y SETTERS
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
func set_target_lane_id(value:int):
	target_lane_id = value
	
	
func _on_area_entered(area):
	if area.name == "coll_auto":
		isCarNearby = true
		emit_signal("car_nearby")  # Emitir la señal

func _on_area_exited(area):
	if area.name == "coll_auto":
		isCarNearby = false


func getMeshInstance():
	for nodo in self.get_children():
		if nodo is MeshInstance3D:
			return nodo
