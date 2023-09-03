extends Node


@rpc("any_peer")
func test(player_role):
	# esta funcion printea el test en los otros jugadores (que es lo que queremos
	# para la demo 1)
	Debug.dprint("test - player: %s" % player_role, 30)

@rpc("any_peer")
func clutch(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	Debug.dprint("clutch pressed- player: "+  player_role + " - pressure: " + str(pressure), 30)

@rpc("any_peer")
func accelerator(player_role, pressure):
	# esta funcion printea la presion puesta en el aceleradoro a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	Debug.dprint("gas pressed- player: "+  player_role + " - pressure: " + str(pressure), 30)
	
@rpc("any_peer")
func brake(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	# (que es lo que queremos para la demo 1)
	Debug.dprint("brake pressed- player: "+  player_role + " - pressure: " + str(pressure), 30)

@rpc("any_peer")
func turn_left(player_role, degree):
	# esta funcion printea grado de giro a la izquierda del volante los otros jugadores 
	# (que es lo que queremos para la demo 1)
	Debug.dprint("giro a la izquiera- player: "+  player_role + " - degree: " + str(degree), 30)
	
@rpc("any_peer")
func turn_right(player_role, degree):
	# esta funcion printea grado de giro a la derecha del volante los otros jugadores 
	# (que es lo que queremos para la demo 1)
	Debug.dprint("giro a la derecha- player: "+  player_role + " - degree: " + str(degree), 30)


