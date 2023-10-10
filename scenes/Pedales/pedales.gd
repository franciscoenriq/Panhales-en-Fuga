extends Node2D


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
	
func _process(_delta):
	
	if Input.is_action_pressed("forward"):
		acc_button_pressed = true
	else:
		acc_button_pressed = false
	
	if Input.is_action_pressed("brake"):
		fre_button_pressed = true
	else:
		fre_button_pressed = false
	if Input.is_action_pressed("clutch"):
		emb_button_pressed = true
	else:
		emb_button_pressed = false
	
	
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
	
	GameController.accelerator.rpc("Pedals",acc_value)
	GameController.brake.rpc("Pedals",fre_value)
	GameController.clutch.rpc("Pedals",emb_value)
	

	

	

