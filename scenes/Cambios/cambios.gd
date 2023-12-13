extends Node2D

var debug = false
var isDragging = false
var mouseInsideAreaPalanca = false
var mouseInsideAreaCambio = false
var areaCambio
var palanca 
var initialPosition
var areaPalanca

# CAMBIOS
var estadoCambios ={
	GameController.Cambios.NEUTRO:false,
	GameController.Cambios.PRIMERO:false,
	GameController.Cambios.SEGUNDO:false,
	GameController.Cambios.TERCERO:false,
	GameController.Cambios.CUARTO:false,
	GameController.Cambios.QUINTO:false 
	}
func _ready():
	#######################
	setCambio(GameController.Cambios.NEUTRO)
	########################
	areaPalanca = %areaPalanca
	palanca  = $CanvasLayer/Palanca
	initialPosition = palanca.global_position
	
func _on_area_palanca_mouse_entered():
	mouseInsideAreaPalanca = true

func _on_area_palanca_mouse_exited():
	mouseInsideAreaPalanca = false
	
func _process(_delta):
	if mouseInsideAreaPalanca:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			isDragging = true
		else:
			isDragging = false
	if isDragging and (GameController.clutchPressure>=GameController.acceptableClutchPressure or debug):
		# el godot se mueve si está arrastrando y el embrague está apretado
		var newPosition = get_global_mouse_position()
		
		if mouseInsideAreaCambio:
			palanca.global_position = newPosition
		else:
			isDragging=false
			
			
func setCambio(cambio):
	# solo pasamos el cambio si el embrague está presionado
	if GameController.clutchPressure>=GameController.acceptableClutchPressure or debug: 
		estadoCambios[cambio] = true
		GameController.set_gear.rpc("shift", cambio)
		for otro_cambio in GameController.Cambios.values():
			if otro_cambio != cambio:
				estadoCambios[otro_cambio] = false
#	else:
#		GameController.messages["shift"] = "Debe presionar el embrague para poder pasar los cambios"
	
func _on_area_cambio_mouse_entered():
	mouseInsideAreaCambio = true


func _on_area_cambio_mouse_exited():
	mouseInsideAreaCambio = false


func _on_primera_area_entered(area):
	if area == areaPalanca:
		setCambio(GameController.Cambios.PRIMERO)
		print("Auto en primera")

func _on_segunda_area_entered(area):
	if area == areaPalanca:
		setCambio(GameController.Cambios.SEGUNDO)
		print("Auto en segunda")
		
func _on_tercera_area_entered(area):
	if area == areaPalanca:
		setCambio(GameController.Cambios.TERCERO)
		print("Auto en tercera")
		
		
func _on_cuarta_area_entered(area):
	if area == areaPalanca:
		setCambio(GameController.Cambios.CUARTO)
		print("Auto en cuarta")
		
func _on_quinta_area_entered(area):
	if area == areaPalanca:
		setCambio(GameController.Cambios.QUINTO)
		print("Auto en quinta")
		
func _on_neutro_area_entered(area):
	if area == areaPalanca:
		setCambio(GameController.Cambios.NEUTRO)
		print("Auto en neutro")
		
		
