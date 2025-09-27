extends RigidBody3D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		apply_impulse(Vector3.UP * 10)
		
func _physics_process(_delta: float) -> void:
	pass
