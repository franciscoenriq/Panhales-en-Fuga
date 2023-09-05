extends VehicleBody3D

func _physics_process(_delta):
	steering = Input.get_axis("left", "right") * 0.4
	engine_force = Input.get_axis("back", "forward") * 100
