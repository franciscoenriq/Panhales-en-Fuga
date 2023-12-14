extends Label
const SAVEFILE = "user://savefile.save"

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	self.text = str(GameController.puntaje)


func save_highscore():
	var scoreboard = get_node("res://scenes/Inicio/scoreboard.gd")
	scoreboard.save_score(GameController.puntaje)

func save_score(score):
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	file.store_var(score)
	file.close()

