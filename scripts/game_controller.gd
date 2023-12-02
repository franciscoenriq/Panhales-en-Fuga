extends Node

var brakePressure=0
var accPressure=0
var clutchPressure=0
var acceptableClutchPressure = 85
var turnValue=0
var cambioActual = Cambios.NONE

var car_speed= 1 # velocidad inicial a la que se mueve la pista en km/h
var velocidad_lateral = car_speed/2  # velocidad para cambiar de pista en km/h
const debug_print_time = 0.8

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
	Cambios.PRIMERO: 4 , 
	Cambios.SEGUNDO: 3 , 
	Cambios.TERCERO: 2 , 
	Cambios.CUARTO: 1.5, 
	Cambios.QUINTO: 1.0
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
	

var default_message = "No input received"
var messages = {"driver": default_message,
				"shift": default_message,
				"pedal": default_message,
				"shooter": default_message }

func calc_aceleracion():
	var fuerza = fuerza_motor[cambioActual]
	#fuerza =1 #sacar
	if accPressure>0 and brakePressure<=0:
		return fuerza * accPressure
	if accPressure<=0 and brakePressure>0:
		return fuerza * brakePressure * -1
	return 0
	

@rpc("any_peer")
func calc_speed(delta):
	var limite = limite_velocidad[cambioActual]
	#limite=100 #sacar
	var velocidad = max(0, car_speed + calc_aceleracion()*delta)
	self.car_speed = min(limite, velocidad)
	self.velocidad_lateral = car_speed/2
	#self.car_speed += 0.1
	print("current speed: " + str(car_speed))
	return self.car_speed #solucion parche

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
	if clutchPressure>=GameController.acceptableClutchPressure:
		if cambio != cambioActual:
			cambioActual = cambio
			change_message("switching gears - player: "+  player_role + " - gear: " + str(str_values[cambio]))
			
			return true
	return false
func isDriving()->bool:
	if car_speed>0:
		return true
	else:
		return false
func set_motor_pitch() -> float:
	var nuevo_pitch = 0.0
	var pitch_base = 1.0

	if limite_velocidad[cambioActual]!=0: # Estamos en una marcha distinta de NULL o Neutro
		var velocidad_maxima = limite_velocidad[cambioActual]
		var velocidad_normalizada = min(1.0, car_speed / velocidad_maxima)
		nuevo_pitch = lerp(pitch_base, 2.0, velocidad_normalizada)
	else:
		#Estamos en neutro, pero igual podemos pisar el acelerador, por lo que el pitch 
		#depende de la presión del pedal del acelerador.
		nuevo_pitch=lerp(pitch_base,2.0,accPressure/100)
	return nuevo_pitch
	

