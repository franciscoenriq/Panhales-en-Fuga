extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var degree = GameController.accPressure
	var direction = "Left" if degree<0 else "Right"
	
	self.text = "Wheel turning: " + str(abs(degree))+"° "+direction
	#self.text = str(abs(degree)) #test
