extends Node

var brakePressure=0
var accPressure=0
var clutchPressure=0
var turnValue=0

enum Cambios {
	NEUTRO,
	PRIMERO,
	SEGUNDO,
	TERCERO,
	CUARTO,
	QUINTO,
	REVERSA,
	NONE
}

const str_values = {
	   Cambios.NEUTRO: "neutro",
	Cambios.PRIMERO: "primera",
	Cambios.SEGUNDO: "segunda",
	Cambios.TERCERO: "tercera",
	Cambios.CUARTO:"cuarta",
	Cambios.QUINTO:"quinta",
	Cambios.REVERSA:"reversa",
	Cambios.NONE: "no válido"
	}
const fuerza_motor ={
		Cambios.NEUTRO : 0,
	Cambios.PRIMERO : 4 , 
	Cambios.SEGUNDO : 3 , 
	Cambios.TERCERO : 2 , 
	Cambios.CUARTO  : 1.5, 
	Cambios.QUINTO : 1.0
	}
	
var cambioActual = Cambios.NONE
var fuerza_motor_actual

var car_speed = 0

const debug_print_time = 0.8

var default_message = "No input received"
var messages = {"driver": default_message,
				"shift": default_message,
				"pedal": default_message,
				"shooter": default_message }



@rpc("any_peer")
func test(player_role):
	Debug.dprint("test - player: %s" % player_role, debug_print_time)

func change_message(message):
	for clave in messages.keys():
		messages[clave] = message
		
	
@rpc("any_peer")
func clutch(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores
	if clutchPressure != pressure:
		clutchPressure = pressure
		if pressure != 0:
			change_message("clutch pressed- player: "+  player_role + " - pressure: " + str(pressure))
		else:
			if accPressure+brakePressure+clutchPressure <= 0:
				change_message(default_message)
				
		
@rpc("any_peer")
func accelerator(player_role, pressure):
	# esta funcion printea la presion puesta en el aceleradoro a  los otros jugadores 
	if accPressure!=pressure:
		accPressure = pressure
		if pressure != 0:
			change_message("gas pressed- player: "+  player_role + " - pressure: " + str(pressure))
			#Aquí se debería acelerar al auto dependiendo del cambio en el que estemos.
			#El cambio primera siempre tiene mas fuerza, el segundo, un 70% de la fuerza y asi sucesivamente en general, los cambios disminuyen la fuerza del motor usando una razón dada
			#El auto deja de acelerar en el cambio dado cuando se superan las RPM del motor ( por ejemplo, en a mayoría de los autos es a 2000 RPM)
			#De momento, el auto solo acelerará de una manera fija 
		else:
			if accPressure+brakePressure+clutchPressure <= 0:
				change_message(default_message)
		
@rpc("any_peer")
func brake(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	if pressure != brakePressure:
		brakePressure = pressure
		if pressure != 0:
			change_message("brake pressed- player: "+  player_role + " - pressure: " + str(pressure))
		else:
			if accPressure+brakePressure+clutchPressure <= 0:
				change_message(default_message)
		
		
func change_degree_value(value):
	var originalScale = value
	var minRange = -1
	var maxRange = 1
	var newMin = -90
	var newMax = 90
	var scaledValue = ((originalScale - minRange) / (maxRange - minRange)) * (newMax - newMin) + newMin
	return snapped(scaledValue, 0.1)

@rpc("any_peer")
func turn(player_role,value):
	if value != turnValue:
		turnValue = value
		if snapped(value,0.1) != 0:
			var direction = "Left" if value<0 else "Right"
			change_message("Player: "+player_role+" - Wheel turning: " + str(abs(change_degree_value(value)))+"° "+direction)
		else:
			change_message(default_message)

@rpc("any_peer")
func set_gear(player_role, cambio: Cambios):
	if cambio != cambioActual:
		cambioActual = cambio
		fuerza_motor_actual = int(fuerza_motor[cambio])
		change_message("switching gears - player: "+  player_role + " - gear: " + str(str_values[cambio]))
		



