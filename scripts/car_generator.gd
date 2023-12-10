extends Node3D

var velocidad_player = GameController.car_speed

var cars_in_lane:Array = []
@export var cars_paths:Array = ["res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_hatchback.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_sedan.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_stationwagon.gltf",
"res://Assets/KayKit_City_Builder_Bits_1.0_FREE/Assets/gltf/car_taxi.gltf"]
var average_speed = 10

@export var cars_spawn_limit_per_lane = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_car_scenes(cars_paths)  # Carga la escena de los autos
	_init_cars(cars_spawn_limit_per_lane)
	
func _init_cars(number_of_cars: int) -> void:
	for car_index in range(cars_spawn_limit_per_lane):
		var pos=randf_range(GameController.distancia_maxima_adelante,GameController.distancia_maxima_atras)
		spawn_car(pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cars_in_lane_count = get_children().size()
	for car in get_children():
		#Asignamos velocidad random 
		var npc_speed = GameController.car_speed-randf_range(-0.3, 1.3) * average_speed
		car.translate(-Vector3(0,0,npc_speed * delta))
		if car.position.z < GameController.distancia_maxima_adelante or car.position.z > GameController.distancia_maxima_atras:
			car.queue_free()
	if cars_in_lane_count<cars_spawn_limit_per_lane:
		spawn_car(GameController.distancia_maxima_atras)
func _load_car_scenes(cars_paths):
	for car_path in cars_paths:
		print("Loading car" + car_path)
		cars_in_lane.append(load(car_path))

	

func spawn_car(position):
	var car = cars_in_lane.pick_random().instantiate()
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

