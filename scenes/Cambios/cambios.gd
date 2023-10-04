extends Node2D

var isDragging = false
var mouseInsideAreaPalanca = false
var mouseInsideAreaCambio = false
var areaCambio
var palanca 
var initialPosition
var areaPalanca

# CAMBIOS

var neutro : bool
var primera : bool
var segunda : bool
var tercera : bool
var cuarta : bool
var quinta : bool
enum Cambios {
	NEUTRO,
	PRIMERO,
	SEGUNDO,
	TERCERO,
	CUARTO,
	QUINTO
}
var estadoCambios ={
	Cambios.NEUTRO:false,
	Cambios.PRIMERO:false,
	Cambios.SEGUNDO:false,
	Cambios.TERCERO:false,
	Cambios.CUARTO:false,
	Cambios.QUINTO:false 
	}
func _ready():
	#######################
	setCambio(Cambios.NEUTRO)
	########################
	areaPalanca = %areaPalanca
	palanca  = $Palanca
	initialPosition = palanca.global_position
	
func _on_area_palanca_mouse_entered():
	mouseInsideAreaPalanca = true

func _on_area_palanca_mouse_exited():
	mouseInsideAreaPalanca = false
	
func _process(delta):
	if mouseInsideAreaPalanca:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			isDragging = true
		else:
			isDragging = false
	if isDragging:
		var newPosition = get_global_mouse_position()
		
		if mouseInsideAreaCambio:
			palanca.global_position = newPosition
		else:
			isDragging=false
			
			
func setCambio(cambio):

	estadoCambios[cambio] = true
	for otro_cambio in Cambios.values():
		if otro_cambio != cambio:
			estadoCambios[otro_cambio] = false
	
func _on_area_cambio_mouse_entered():
	mouseInsideAreaCambio = true


func _on_area_cambio_mouse_exited():
	mouseInsideAreaCambio = false


func _on_primera_area_entered(area):
	if area == areaPalanca:
		setCambio(Cambios.PRIMERO)
		print("Auto en primera")

func _on_segunda_area_entered(area):
	if area == areaPalanca:
		setCambio(Cambios.SEGUNDO)
		print("Auto en segunda")
		
func _on_tercera_area_entered(area):
	if area == areaPalanca:
		setCambio(Cambios.TERCERO)
		print("Auto en tercera")
		
		
func _on_cuarta_area_entered(area):
	if area == areaPalanca:
		setCambio(Cambios.CUARTO)
		print("Auto en cuarta")
		
func _on_quinta_area_entered(area):
	if area == areaPalanca:
		setCambio(Cambios.QUINTO)
		print("Auto en quinta")
		
func _on_neutro_area_entered(area):
	if area == areaPalanca:
		setCambio(Cambios.NEUTRO)
		print("Auto en neutro")
		
		
		
