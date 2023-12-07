extends Sprite2D

var speed = 250
var time_elapsed = 0
var move_interval = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta  # Actualiza el tiempo transcurrido
	if time_elapsed >= move_interval:  # Comprueba si ha pasado el intervalo de tiempo
		move_letras()
		time_elapsed = 0
	
func move_letras():
	position.y -= speed * get_process_delta_time()

