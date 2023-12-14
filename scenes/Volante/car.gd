extends CharacterBody3D

@export var sensitivity = 1000
@onready var pivoteCamera := $pivoteCamera
var timer = 10
var isTurningLeft: bool
var isTurningRight: bool
@onready var volante=%MeshInstance3D
var turningRate: float = 5.0  # Aumenta la velocidad de giro
var forceFeedback: float = 3.0
var maxWheelAngle: float = 90.0
var wheelRotationValue: float

var bullet = preload("res://scenes/Shooter/Bullet.tscn")
var instance 
@onready var head = $Head
@onready var camera =$Head/Camera3D
@onready var gun_anim = $Head/Camera3D/Rifle/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/Rifle/RayCast3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.3



func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func _ready() -> void:
	isTurningLeft = false
	isTurningRight = false
	wheelRotationValue = 0

func _physics_process(delta: float) -> void:
	timer -=delta
	print(timer)
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("Shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position 
			instance.transform.basis = gun_barrel.global_transform.basis 
			get_parent().add_child(instance)

	
	#Ahora debemos girar al auto hacia la derecha o izquierda segun corresponda mediante el volante.
	var turn = GameController.current_turn
	if turn:
		velocity.x = turn*GameController.velocidad_lateral
	else:

		velocity.x = move_toward(velocity.x,0,GameController.velocidad_lateral)

	#print(global_position)
	

	var collision = get_last_slide_collision()
	if collision && timer <=0 :
		print("colisionado con auto")
		GameController.fin_de_juego()
		GameController.fin_de_juego.rpc()
	move_and_slide()
