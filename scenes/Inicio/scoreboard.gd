extends Node
const SAVEFILE = "user://savefile.save"
var highest_record = 0
@onready var record_label = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/record

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_button_main_pressed():
	get_tree().change_scene_to_file("res://scenes/Inicio/main_menu.tscn")

func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		file.open(SAVEFILE, FileAccess.READ)
		highest_record = file.get_var()
		file.close()

func update_record_label():
	record_label.text = "Record: " + str(GameController.puntaje)

