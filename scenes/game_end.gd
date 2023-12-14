extends Label

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	self.text = str(GameController.puntaje)


func save_highscore():
	var scoreboard = get_node("/root/Scoreboard") # Reemplaza "/root/Scoreboard" con la ruta correcta a tu nodo scoreboard
	scoreboard.save_score()
