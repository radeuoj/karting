extends RayCast3D
class_name Wheel

@export var is_motor := false
@export var can_steer := false

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var kart: Kart = $".."

func is_on_ground() -> bool:
	if not is_colliding():
		return false
		
	var contact := get_collision_point()
	var up := global_basis.y
	var length := up.dot(global_position) - up.dot(contact) - kart.wheel_radius
	var offset := kart.rest_distance - length
	
	if offset <= 0:
		return false
		
	return true
	
func get_wheel_pos() -> Vector3:
	return mesh.position + position
