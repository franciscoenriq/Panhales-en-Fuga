extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players


func _ready() -> void:
	for player_data in Game.players:
		var player = player_scene.instantiate()
		players.add_child(player)
		player.setup(player_data)
		get_tree().change_scene_to_file(Game.get_role_scene(player_data.role))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
