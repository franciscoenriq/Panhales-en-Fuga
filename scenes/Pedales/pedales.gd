extends Node2D

@onready var AccBTN = %AccBTN
@onready var FreBTN = %FreBTN
@onready var EmbBTN = %EmbBTN
@onready var ProgressAcc = %ProgressBarAcc
@onready var ProgressFre = %ProgressBarFre
@onready var ProgressEmb = %ProgressBarEmb

var progressAccFillRate  = 0.7
var acc_button_pressed = false
var acc_value

var progressFreFillRate = 2
var fre_button_pressed = false
var fre_value

var progressEmbFillRate = 1.2
var emb_button_pressed = false
var emb_value 

func _ready():
	pass
	
func _process(delta):
	
	
	###############ACELERADOR#####################
	if acc_button_pressed ==true:
		if (ProgressAcc.value <ProgressAcc.max_value):
			ProgressAcc.value +=progressAccFillRate
	
	if acc_button_pressed == false:
		ProgressAcc.value = 0
			
			
	################FRENO######################
	if fre_button_pressed ==true:
		if (ProgressFre.value <ProgressFre.max_value):
			ProgressFre.value +=progressFreFillRate
	
	if fre_button_pressed == false:
		ProgressFre.value = 0
		
	##################EMBRAGUE############################
	if emb_button_pressed ==true:
		if (ProgressEmb.value <ProgressEmb.max_value):
			ProgressEmb.value +=progressEmbFillRate
	
	if emb_button_pressed == false:
		ProgressEmb.value = 0
				
	acc_value = ProgressAcc.value
	fre_value = ProgressFre.value
	emb_value = ProgressEmb.value
	
	GameController.accelerator(name,acc_value)
	GameController.brake(name,fre_value)
	GameController.clutch(name,emb_value)
	

	
	
	

func _on_acc_btn_button_up():
	print("acelerador soltado")

	acc_button_pressed = false
	
func _on_acc_btn_button_down():
	print("acelerador presionado")
	acc_button_pressed = true
	

func _on_fre_btn_button_up():
	print("freno soltado")
	fre_button_pressed = false
	
	
func _on_fre_btn_button_down():
	print("freno presionado")
	fre_button_pressed = true
	

func _on_emb_btn_button_up():
	print("embrague soltado")
	emb_button_pressed = false
	
func _on_emb_btn_button_down():
	print("embrague presionado")
	emb_button_pressed = true
