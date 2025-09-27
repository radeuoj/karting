extends RayCast3D
class_name Wheel

@export var wheel_radius := 0.2
@export var is_motor := false

@onready var mesh: MeshInstance3D = $MeshInstance3D
