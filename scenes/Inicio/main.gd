extends Node2D

@export var player_scene: PackedScene
@onready var driver_scene: PackedScene = preload("res://scenes/Volante/new_volante.tscn")
@onready var pedal_scene: PackedScene = preload("res://scenes/Pedales/pedales.tscn")
@onready var shift_scene: PackedScene= preload("res://scenes/Cambios/cambios.tscn")
@onready var shooter_scene: PackedScene= preload("res://scenes/dummy.tscn")

@onready var players: Node2D = $Players
@onready var root = $"."

func _ready() -> void:
	for player_data in Game.players:
		var player = player_scene.instantiate()
		players.add_child(player)
		player.setup(player_data)
		
	var myscene
	var current_player = Game.get_current_player()
	match  current_player.role:
		Game.Role.DRIVER:
			myscene = driver_scene.instantiate()
		Game.Role.PEDAL:
			myscene = pedal_scene.instantiate()
		Game.Role.SHIFT:
			myscene = shift_scene.instantiate()
		Game.Role.SHOOTER:
			myscene = shooter_scene.instantiate()
	root.add_child(myscene)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Manejamos el audio de la escena
	$AudioMotor.pitch_scale = GameController.set_motor_pitch()
	
