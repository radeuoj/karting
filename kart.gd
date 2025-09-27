extends RigidBody3D

@export_group("Wheels")
@export var wheels: Array[Wheel]

@export_group("Suspension")
@export var suspension_strength := 10000.0
@export var damping_strength := 320.0
@export var rest_distance := 0.1

@export_group("Acceleration")
@export var acceleration_strength := 1000.0
@export var brake_strength := 1000.0
@export var drag_coef := 100.0

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		apply_force(Vector3.UP * mass * 20)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		apply_torque_impulse(Vector3.FORWARD * mass)
	
	for wheel in wheels:
		handle_suspension(wheel)
		handle_acceleration(wheel, delta)
		
	# drag
	var drag_force := -linear_velocity.normalized() * linear_velocity.length_squared() * drag_coef
	apply_force(drag_force)
		
func get_point_velocity(point: Vector3) -> Vector3:
	return linear_velocity + angular_velocity.cross(point - global_position)
		
func handle_suspension(wheel: Wheel) -> void:
	if !wheel.is_colliding(): 
		wheel.mesh.position.y = -rest_distance
		return
	
	var contact := wheel.get_collision_point()
	var up := wheel.global_basis.y
	var length := up.dot(wheel.global_position) - up.dot(contact) - wheel.wheel_radius
	var offset := rest_distance - length
	
	if offset <= 0:
		return
	
	wheel.mesh.position.y = -length
	
	var suspension_force := suspension_strength * offset
	
	var world_vel := get_point_velocity(contact)
	var relative_vel := up.dot(world_vel)
	var damping_force := damping_strength * relative_vel
	
	var force = (suspension_force - damping_force) * up
	var force_pos := wheel.position - up * length;
	
	apply_force(force, force_pos)
	#DebugDraw3D.draw_arrow_ray(force_pos + global_position, force / mass, 1, Color.BLUE, 0.05)
	
func handle_acceleration(wheel: Wheel, delta: float):
	if !wheel.is_colliding():
		return
		
	var contact := wheel.get_collision_point()
	var up := wheel.global_basis.y
	var length := up.dot(wheel.global_position) - up.dot(contact) - wheel.wheel_radius
	var offset := rest_distance - length
	
	if offset <= 0:
		return
		
	var force := Vector3.ZERO
		
	if wheel.is_motor:
		var acceleration_input := Input.get_action_strength("acceleration")
		var gear_input := -1 if Input.is_action_pressed("reverse") else 1
		var acceleration_force := -wheel.global_basis.z * gear_input * acceleration_strength * acceleration_input
		force += acceleration_force
		
	var brake_input := Input.get_action_strength("brake")
	var forward = -wheel.global_basis.z
	var brake_force = forward * forward.dot(-linear_velocity.normalized() * brake_strength * brake_input)
	
	if linear_velocity.length_squared() > 0.2:
		force += brake_force
	elif brake_input > 0:
		linear_velocity = Vector3.ZERO
	
	var force_pos := wheel.position - up * length;
	
	apply_force(force, force_pos)
	#DebugDraw3D.draw_arrow_ray(force_pos + global_position, force / mass, 1, Color.GREEN, 0.05)
	
	# wheel spin
	var vel := forward.dot(linear_velocity)
	var ang_vel := -vel * 2 * PI * wheel.wheel_radius
	wheel.mesh.rotate_x(ang_vel * delta)
	
	
