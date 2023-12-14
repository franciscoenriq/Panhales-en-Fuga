extends CanvasLayer
const SAVEFILE = "user://savefile.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_button_main_pressed():
	get_tree().change_scene_to_file("res://scenes/Inicio/main_menu.tscn")

func save_score():
	
