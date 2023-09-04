class_name Player
extends Node2D



func setup(player_data: Game.PlayerData):
	set_multiplayer_authority(player_data.id)
	name = str(player_data.id)
	Debug.dprint(player_data.name, 30)
	Debug.dprint(player_data.role, 30)


func _input(event: InputEvent) -> void:
	
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			GameController.test.rpc(name)
			
		if event.is_action_pressed("clutch"):
			GameController.clutch.rpc(name, 100)
	
		if event.is_action_pressed("brake"):
			GameController.brake.rpc(name, 100)
		
		if event.is_action_pressed("gas"):
			GameController.accelerator.rpc(name, 100)
		
		if event.is_action_pressed("turn_left"):
			GameController.turn_left.rpc(name, 90)
		
		if event.is_action_pressed("turn_right"):
			GameController.turn_right.rpc(name, 90)


