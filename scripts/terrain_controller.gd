extends Node3D
class_name TerrainController

var TerrainBlocks: Array = []
var terrain_belt: Array[MeshInstance3D] = []
@export var num_terrain_blocks = 16
@export_dir var terrian_blocks_path = "res://terrain_blocks"


func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	_init_blocks(num_terrain_blocks)

func _init_blocks(number_of_blocks: int) -> void:
	for block_index in range(number_of_blocks):
		var block = TerrainBlocks.pick_random().instantiate()
		block.position.z = block.mesh.size.y * (block_index-num_terrain_blocks/2)
		add_child(block)
		terrain_belt.append(block)
		
		GameController.distancia_maxima_adelante +=block.mesh.size.y*(block_index-num_terrain_blocks/2)
		GameController.distancia_maxima_atras -=block.mesh.size.y*(block_index-num_terrain_blocks/2)
		
func _process(delta):
	_progress_terrain(delta)


func _progress_terrain(delta: float) -> void:
	var velocidad = GameController.calc_speed(delta)
	GameController.calc_distance(delta)
	print("llamando calc_speed")
	for block in terrain_belt:
		block.position.z += velocidad * delta

	var first_terrain = terrain_belt[0]
	var last_terrain = terrain_belt[-1]

	if first_terrain.position.z >= first_terrain.mesh.size.y:
		terrain_belt.pop_front()
		first_terrain.queue_free()

		var new_block = TerrainBlocks.pick_random().instantiate()
		new_block.position.z = last_terrain.position.z - last_terrain.mesh.size.y
		add_child(new_block)
		terrain_belt.append(new_block)


func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrain block scene: " + target_path + "/" + scene_path)
		TerrainBlocks.append(load(target_path + "/" + scene_path))
