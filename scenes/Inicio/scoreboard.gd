extends Node
const SAVEFILE = "res://file.txt"

@onready var record_label = $CanvasLayer/Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/record

# Called when the node enters the scene tree for the first time.
func _ready():
	load_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_button_main_pressed():
	get_tree().change_scene_to_file("res://scenes/Inicio/main_menu.tscn")

func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		print("contenido:", content)
		GameController.set_highest.rpc(content.to_int())
		GameController.set_highest(content.to_int())
		print("highest:", GameController.highest_record)
		file.close()






