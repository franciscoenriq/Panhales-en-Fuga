extends Node

var brakePressure=0
var accPressure=0
var clutchPressure=0
var acceptableClutchPressure = 85
var turnValue=0
var cambioActual = Cambios.NONE
var current_turn
var car_speed= 1 # velocidad inicial a la que se mueve la pista en km/h
var velocidad_lateral = car_speed/2  # velocidad para cambiar de pista en km/h
const debug_print_time = 0.8
var gameOver = false
var time = 0
var distance_traveled = 0
var last_update_time = 0

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
	Cambios.NONE: 0,
	Cambios.NEUTRO: 0,
	Cambios.PRIMERO: 1 , 
	Cambios.SEGUNDO: 0.7 , 
	Cambios.TERCERO: 0.5 , 
	Cambios.CUARTO: 0.25, 
	Cambios.QUINTO: 0.1
	}
	
const limite_velocidad ={
	Cambios.NONE: 0,
	Cambios.NEUTRO: 0,
	Cambios.PRIMERO: 25 , 
	Cambios.SEGUNDO: 40 , 
	Cambios.TERCERO: 65, 
	Cambios.CUARTO: 100, 
	Cambios.QUINTO: 150
	}


	



func calc_aceleracion():
	var fuerza = fuerza_motor[cambioActual]
	#fuerza =1 #sacar
	if accPressure>0 and brakePressure<=0:
		return fuerza * accPressure
	if accPressure<=0 and brakePressure>0:
		return brakePressure * -1  # el frenado deja de depender del motor
	return 0
	

@rpc("any_peer")
func calc_speed(delta):
	var limite = limite_velocidad[cambioActual]
	var velocidad = max(0, car_speed + calc_aceleracion()*delta)
	self.car_speed = min(limite, velocidad)
	self.velocidad_lateral = car_speed/2
	#print("current speed: " + str(car_speed))
	return self.car_speed

@rpc("any_peer")
func calc_distance(delta):
	
	var current_time = time # Calcular el tiempo transcurrido desde la última actualización
	var elapsed_time = current_time - last_update_time
	# Calcular la distancia recorrida desde la última actualización
	var distance_since_last_update = (self.car_speed * elapsed_time) / 3600  # Convertir la velocidad de km/h a km/s
	distance_traveled += distance_since_last_update # Actualizar la distancia total recorrida
	last_update_time = current_time 
	print("Distance Traveled: " + str(distance_traveled) + " m")    # Mostrar la distancia recorrida
	

@rpc("any_peer")
func test(player_role):
	print("test - player: %s" % player_role, debug_print_time)

@rpc("any_peer")
func clutch(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores
	if clutchPressure != pressure:
		clutchPressure = pressure
	
@rpc("any_peer")
func accelerator(player_role, pressure):
	# esta funcion printea la presion puesta en el aceleradoro a  los otros jugadores 
	if accPressure!=pressure:
		accPressure = pressure

@rpc("any_peer")
func brake(player_role, pressure):
	# esta funcion printea la presion puesta en el freno a  los otros jugadores 
	if pressure != brakePressure:
		brakePressure = pressure


@rpc("any_peer")
func turn(player_role,value):
	if value != turnValue:
		turnValue = value

@rpc("any_peer")
func set_gear(player_role, cambio: Cambios):
	if clutchPressure>=GameController.acceptableClutchPressure:
		if cambio != cambioActual:
			cambioActual = cambio
			return true
	return false

func isDriving()->bool:
	if car_speed>0:
		return true
	else:
		return false
		
var marcha_anterior = Cambios.NONE

var transicion_pitch = 1.0
var velocidad_transicion = 0.1  # Ajusta según tus necesidades

func set_motor_pitch(delta) -> float:
	var nuevo_pitch = 0.0
	var pitch_base = 1.0

	if limite_velocidad[cambioActual] != 0:  # Estamos en una marcha distinta de NULL o Neutro
		var velocidad_maxima = limite_velocidad[cambioActual]
		var velocidad_normalizada = min(1.0, car_speed / velocidad_maxima)
		nuevo_pitch = lerp(pitch_base, 3.0, velocidad_normalizada)
	else:
		# Estamos en neutro, pero igual podemos pisar el acelerador, por lo que el pitch 
		# depende de la presión del pedal del acelerador.
		nuevo_pitch = lerp(pitch_base, 3.0, accPressure / 100)

	# Verificar si se ha cambiado de marcha
	if cambioActual != marcha_anterior:
		# Ajustar el pitch gradualmente
		transicion_pitch += velocidad_transicion * delta  # delta es el tiempo desde la última llamada

		# Limitar la transición entre 0.0 y 1.0
		transicion_pitch = clamp(transicion_pitch, 0.0, 1.0)

		# Aplicar el pitch gradualmente
		nuevo_pitch *= transicion_pitch

		# Si la transición ha llegado a 1.0, el cambio de pitch ha finalizado
		if transicion_pitch >= 1.0:
			transicion_pitch = 1.0
			marcha_anterior = cambioActual
		else:
			# Si no ha llegado a 1.0, la transición continúa en la próxima llamada
			return nuevo_pitch

	return nuevo_pitch

@rpc("any_peer")
func fin_de_juego():
	gameOver = true

	
func get_speed()->String:
	return str(car_speed)
func get_bra_pressure()->String:
	return str(brakePressure)
func get_clutch_pressure()->String:
	return str(clutchPressure)
func get_gas_pressure()->String:
	return str(accPressure)
func get_gear()->String:
	return str_values[cambioActual]
