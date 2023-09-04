extends CanvasLayer
@onready var main:Control = $Main
@onready var settings:Control = $Settings




func _on_button_play_pressed():
	pass # Replace with function body.

func _on_button_settings_pressed():
	main.visible = false
	settings.visible = true
	
func _on_button_credits_pressed():
	pass # Replace with function body.

func _on_button_exit_pressed():
	get_tree().quit()

func _on_button_settings_back_pressed():
	main.visible = true
	settings.visible = false
