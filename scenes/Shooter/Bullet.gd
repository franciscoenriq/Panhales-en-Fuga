extends Node3D

const SPEED = 40.0 
@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
var area_colision
# Called when the node enters the scene tree for the first time.
func _ready():
	var colision_area = Area3D.new()
	colision_area.name="area_colision_bala"
	self.add_child(colision_area)
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape=BoxShape3D.new()
	colision_area.add_child(collision_shape)
	collision_shape.shape.extents = Vector3(1,1,1)
	area_colision = $area_colision_bala
	area_colision.area_entered.connect(self._on_area_entered)

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false 
		particles.emitting = true 
		await get_tree().create_timer(1.0).timeout
		queue_free()
		var auto = ray.get_collider()
		print(auto)
		print("hola")


func _on_timer_timeout():
	queue_free() # Replace with function body.
func _on_area_entered(area):
	if area.name == "coll_auto":
		var auto = area.get_parent()
		auto.queue_free()


	
