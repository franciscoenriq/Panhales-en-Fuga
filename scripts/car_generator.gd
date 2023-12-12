extends Node3D

class_name car_generator
@export var pista_id:int
var velocidad_player = GameController.car_speed
var safe_distance = 20
var cars_in_lane:Array = []
var police_in_lane:Array =[]
@export var cars_paths:Array = ["res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_hatchback.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_sedan.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_stationwagon.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_taxi.gltf"]
@export var police_path = "res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_police.gltf"
var average_speed = 10
var player
@export var cars_spawn_limit_per_lane = 5
var police_spawner_timer = 10 #Se spawnea un policia cada 10 segundos , se puede modificar
var is_police_in_lane = false
var lanes:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player =get_node("../car_2")
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
		if car.name !="police":
			#Asignamos velocidad random 
			var npc_speed
			var objetivo
			if pista_id>0:
				npc_speed= GameController.car_speed-randf_range(-0.3, 1.3) * average_speed * 5
				objetivo = -Vector3(0, 0, npc_speed * delta)
			else:
				npc_speed= -GameController.car_speed-randf_range(-0.3, 1.3) * average_speed * 5
				objetivo = Vector3(0, 0, npc_speed * delta)
			var new_position = car.global_transform.origin.lerp(
				car.global_transform.origin + objetivo,
				delta*npc_speed  # Ajusta este valor según la suavidad deseada (0.0 a 1.0)
			)
			car.global_transform.origin = new_position
			var prob = 0.01
			if randf()<prob:
				#cambiamos de carril
				var random_lane_id
				if pista_id> 0:
					random_lane_id = randi_range(1, 2)
				else:
					random_lane_id = randi_range(-2, -1)
				if random_lane_id!=pista_id:
					switch_lane(car,random_lane_id,delta)
		if car.name =="police":
			
			var police_speed = average_speed*1.1 # Velocidad mayor para persecución
			var player_direction = (player.global_transform.origin)
			car.look_at(player_direction)
			car.translate(-Vector3(0,0,police_speed*delta))
			
			
		if car.position.z < GameController.distancia_maxima_adelante or car.position.z > GameController.distancia_maxima_atras:
			car.queue_free()
	if cars_in_lane_count<cars_spawn_limit_per_lane:
		spawn_car(GameController.distancia_maxima_atras,false)
		
	if police_spawner_timer<0 && is_police_in_lane ==false:
		spawn_police(GameController.distancia_maxima_atras)
		is_police_in_lane = true
		police_spawner_timer=5
		
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
	if isPolice :
		car.name="police"
	else:
		car.name = "car"


	
func _load_police_scenes(police_path):
	police_in_lane.append(load(police_path))
	print("loading police scene")
	
func spawn_police(position):
	spawn_car(position,true)


func switch_lane(car,lane_id:int,delta):
	var current_lane = pista_id
	#Cambiaremos a la otra pista. 
	#Para ello, necesitamos saber la posición en x en la que está la pista a la que queremos cambiar
	#Primero, obtengamos el nodo que simboliza al carril que queremos cambiar.
	var pista = get_pista(lane_id)
	#Con el nodo obtenido, ahora deberemos de acceder a su posicion en x
	var pista_x_pos = pista.global_transform.origin.x
	#Ahora debemos interpolar la posicion actual del auto con la objetivo
	var target_position = car.global_transform
	target_position.origin.x = pista_x_pos
	# Calculamos el desplazamiento total durante la transición
	var change_lane_speed = average_speed*2 # Ajusta este valor según la velocidad deseada
	target_position.origin.z = change_lane_speed*delta
	# Actualizamos la posición del automóvil usando el delta
	car.global_transform.origin = car.global_transform.origin.lerp(target_position.origin,
	delta*5)

func get_lanes():	
	var nodo_padre = self.get_parent()
	if nodo_padre:
		for child in nodo_padre.get_children():
			if child.has_method("get_pista_id") && child.get_pista_id()!=null:
				lanes.append(child)
			else:
				print("no se encuentran pistas en la escena")
func get_pista(id_pista:int):
	for pista in lanes:
		if pista.get_pista_id()==id_pista:
			return pista

func get_pista_id():
	return pista_id
