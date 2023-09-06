extends Node

var brakePressure=0
var accPressure=0
var clutchPressure=0
var turnValue=0
const debug_print_time = 0.8

var volanteText = "No pedals have been pressed"
var pedalesText = "Wheel straight"

var car_speed = 0

@rpc("any_peer")
func test(player_role):
	# esta funcion printea el test en los otros jugadores (que es lo que queremos
	# para la demo 1)
	Debug.dprint("test - player: %s" % player_role, debug_print_time)

@rpc("any_peer")
func clutch(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	if clutchPressure != pressure:
		clutchPressure = pressure
		if pressure != 0:
			volanteText = "clutch pressed- player: "+  player_role + " - pressure: " + str(pressure)
		else:
			if accPressure+brakePressure+clutchPressure <= 0:
				volanteText = "No pedals have been pressed"
		#Debug.dprint(volanteText)
		
@rpc("any_peer")
func accelerator(player_role, pressure):
	# esta funcion printea la presion puesta en el aceleradoro a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	if accPressure!=pressure:
		accPressure = pressure
		if pressure != 0:
			volanteText = "gas pressed- player: "+  player_role + " - pressure: " + str(pressure)
		else:
			if accPressure+brakePressure+clutchPressure <= 0:
				volanteText = "No pedals have been pressed"
		#Debug.dprint(volanteText)
		
@rpc("any_peer")
func brake(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	if pressure != brakePressure:
		brakePressure = pressure
		if pressure != 0:
			volanteText="brake pressed- player: "+  player_role + " - pressure: " + str(pressure)
		else:
			if accPressure+brakePressure+clutchPressure <= 0:
				volanteText = "No pedals have been pressed"
		#Debug.dprint(volanteText)
		
		
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
			pedalesText = "Player: "+player_role+" - Wheel turning: " + str(abs(change_degree_value(value)))+"° "+direction
		else:
			pedalesText = "Wheel straight"
		#Debug.dprint(pedalesText)



