extends Node

var brakePressure
var accPressure
var clutchPressure
var turnValue

@rpc("any_peer")
func test(player_role):
	# esta funcion printea el test en los otros jugadores (que es lo que queremos
	# para la demo 1)
	Debug.dprint("test - player: %s" % player_role, 30)

@rpc("any_peer")
func clutch(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	clutchPressure = pressure
	if pressure!=0:
		
		Debug.dprint("clutch pressed- player: "+  player_role + " - pressure: " + str(pressure), 1)

@rpc("any_peer")
func accelerator(player_role, pressure):
	# esta funcion printea la presion puesta en el aceleradoro a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	accPressure = pressure
	if pressure!=0:
		
		Debug.dprint("gas pressed- player: "+  player_role + " - pressure: " + str(pressure), 1)
	
@rpc("any_peer")
func brake(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	brakePressure = pressure
	if pressure!=0:
		Debug.dprint("brake pressed- player: "+  player_role + " - pressure: " + str(pressure), 1)

@rpc("any_peer")
func turn(player_role,value):
	turnValue = value
	if turnValue!=0:
		Debug.dprint("turn executed - player: " + player_role + " - turn " + str(value) , 1)
	



