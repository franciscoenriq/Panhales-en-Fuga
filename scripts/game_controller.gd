extends Node

var brakePressure
var accPressure
var clutchPressure
var turnValue
const debug_print_time = 0.8

var volanteText = "Texto inicial"
var pedalesText = "Texto inicial"

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
		#Debug.dprint("clutch pressed- player: "+  player_role + " - pressure: " + str(pressure), debug_print_time)
		self.volanteText = "clutch pressed- player: "+  player_role + " - pressure: " + str(pressure)
		
@rpc("any_peer")
func accelerator(player_role, pressure):
	# esta funcion printea la presion puesta en el aceleradoro a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	if accPressure!=pressure:
		accPressure = pressure
		#Debug.dprint("gas pressed- player: "+  player_role + " - pressure: " + str(pressure), debug_print_time)
		self.volanteText = "gas pressed- player: "+  player_role + " - pressure: " + str(pressure)
		
@rpc("any_peer")
func brake(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	if pressure != brakePressure:
		brakePressure = pressure
		#Debug.dprint("brake pressed- player: "+  player_role + " - pressure: " + str(pressure), debug_print_time)
		self.volanteText="brake pressed- player: "+  player_role + " - pressure: " + str(pressure)
		#Debug.dprint(volanteText)

@rpc("any_peer")
func turn(player_role,value):
	if value != turnValue:
		turnValue = value
		#Debug.dprint("turn executed - player: " + player_role + " - turn " + str(value) , debug_print_time)
		self.pedalesText = "turn executed - player: " + player_role + " - turn " + str(value)
		#Debug.dprint(pedalesText)
	



