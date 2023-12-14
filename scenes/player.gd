class_name Player
extends Node2D

var current_player_data

const text_time = 1


func setup(player_data: Game.PlayerData):
	set_multiplayer_authority(player_data.id)
	#name = str(player_data.id)
	var data = player_data.to_dict()
	current_player_data = data
	#Debug.dprint("Ingresa: " + str(data["name"]) + "- Role: "+ Game.role_str(data["role"]), text_time)

func _input(event: InputEvent) -> void:
	var role =  str(current_player_data["name"])
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			GameController.test.rpc(role, text_time)

		if event.is_action_pressed("clutch"):
			GameController.clutch.rpc(role, 100)

		if event.is_action_pressed("brake"):
			GameController.brake.rpc(role, 100)

		if event.is_action_pressed("gas"):
			GameController.accelerator.rpc(role, 100)

		if event.is_action_pressed("turn_left"):
			GameController.turn.rpc(role, -1)

		if event.is_action_pressed("turn_right"):
			GameController.turn.rpc(role, 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$AudioMotor.playing=true;

func _process(delta: float) -> void:
	if GameController.isDriving()==true:
		$AudioInterior.playing = true
	else:
		$AudioInterior.playing = false

	$AudioMotor.pitch_scale = GameController.set_motor_pitch(delta)
	


