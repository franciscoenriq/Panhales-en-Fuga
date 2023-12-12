extends Node3D

class_name car_generator
@export var pista_id:int
var velocidad_player = GameController.car_speed
var cars_in_lane:Array = []
var police_in_lane:Array =[]
@export var cars_paths:Array = ["res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_hatchback.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_sedan.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_stationwagon.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_taxi.gltf"]
@export var police_path = "res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_police.gltf"

var player
@export var cars_spawn_limit_per_lane = 5
var police_spawner_timer = 10 #Se spawnea un policia cada 10 segundos , se puede modificar
var is_police_in_lane = false
var lanes:Array = []
var codigo_auto = "res://scripts/car_npc.gd"
var lane_change_prob = 0.001
# Called when the node enters the scene tree for the first time.
func _ready():
	player =get_node("../car2")
	_load_car_scenes(cars_paths)  # Carga la escena de los autos
	_load_police_scenes(police_path)
	_init_cars(cars_spawn_limit_per_lane)
	get_lanes()
func _init_cars(number_of_cars: int) -> void:
	for car_index in range(cars_spawn_limit_per_lane):
		var pos=randf_range(GameController.distancia_maxima_adelante,GameController.distancia_maxima_atras)
		spawn_car(pos,false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	police_spawner_timer-=delta
	var cars_in_lane_count = get_children().size()
	
	for car in get_children():

		#Movemos al auto (se hace en el script de car_npc.gd)
		#Cambio de carril:
		if car.get_isSwitchingLane()==false && randf()<lane_change_prob:
			#cambiamos de carril
			var random_lane_id
			if car.get_pistaid()> 0:
				random_lane_id = randi_range(1, 2)
			else:
				random_lane_id = randi_range(-2, -1)
			if random_lane_id!=car.get_pistaid():
				var current_lane_pos = get_pista(pista_id)
				var target_lane_pos= get_pista(random_lane_id)
				current_lane_pos=current_lane_pos.global_transform.origin
				target_lane_pos=target_lane_pos.global_transform.origin
				car.set_current_lane_pos(current_lane_pos)
				car.set_target_lane_pos(target_lane_pos)
				car.set_isSwitchingLane(true)
				print("cambiando de carril")
		if car.position.z < GameController.distancia_maxima_adelante or car.position.z > GameController.distancia_maxima_atras:
			car.queue_free()
	if cars_in_lane_count<cars_spawn_limit_per_lane:
		spawn_car(GameController.distancia_maxima_atras,false)
		
func _load_car_scenes(cars_paths):
	for car_path in cars_paths:
		print("Loading car" + car_path)
		cars_in_lane.append(load(car_path))

func spawn_car(position, isPolice):
	var car
	if isPolice:
		car = police_in_lane.pick_random().instantiate() 
	if not isPolice:
		car = cars_in_lane.pick_random().instantiate()	
	car.position.z=position
	car.position.y = 0.3
	car.scale= Vector3(4,4,4)
	car.rotate_y(deg_to_rad(180))
	add_child(car)
	var collision_shape = CollisionShape3D.new()
	collision_shape.transform = car.transform
	collision_shape.shape = BoxShape3D.new()
	collision_shape.shape.extents = car.scale / 2.0  # Ajusta las dimensiones de la caja de colisión según la escala del auto
	car.add_child(collision_shape)
	car.set_script(load("res://scripts/car_npc.gd"))
	car.set_process(true)
	car._ready()
	
	
	if isPolice :
		car.set_isPolice(true)
	else:
		car.set_isPolice(false)
		var car_script=load(codigo_auto)
		car.set_script(car_script)

	car.set_pistaid(pista_id)
	
func _load_police_scenes(police_path):
	police_in_lane.append(load(police_path))
	print("loading police scene")
	
func spawn_police(position):
	spawn_car(position,true)



func get_lanes():	
	var nodo_padre = self.get_parent()
	if nodo_padre:
		for child in nodo_padre.get_children():
			if child.has_method("get_pista_id") && child.get_pista_id()!=null:
				lanes.append(child)


func get_pista(id_pista:int):
	for pista in lanes:
		if pista.get_pista_id()==id_pista:
			return pista

func get_pista_id():
	return pista_id
