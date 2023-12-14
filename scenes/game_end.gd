extends Label

func _ready():
	pass

func _process(_delta):
	self.text = str(GameController.distance_traveled)

func save_highscore():
	var scoreboard = get_node("/root/Scoreboard") # Reemplaza "/root/Scoreboard" con la ruta correcta a tu nodo scoreboard
	scoreboard.save_score()

