extends Label
const SAVEFILE = "res://file.txt"

func _ready():
	save_score(GameController.puntaje)


func _process(_delta):
	self.text = str(GameController.puntaje)


func save_highscore():
	save_score(GameController.puntaje)

func save_score(content):
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	if file:
		file.store_string(str(content))
	file.close()

