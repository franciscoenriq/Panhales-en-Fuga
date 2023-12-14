extends Node

const SAVEFILE = "user://savefile.save"
var highest_record = 0
@onready var record_label = $Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/record

func _ready():
	load_score()
	update_record_label()

func _on_button_main_pressed():
	get_tree().change_scene("res://scenes/Inicio/main_menu.tscn")

func save_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	file.store_32(highest_record)
	file.close()

func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		file.open(SAVEFILE, FileAccess.READ)
		highest_record = file.get_var()
		file.close()

func update_record_label():
	record_label.text = "Record: " + str(highest_record)
