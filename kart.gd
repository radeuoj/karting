extends RigidBody3D
class_name Kart

@export_group("Wheels")
@export var wheels: Array[Wheel]
@export var wheel_radius := 0.2

@export_group("Suspension")
@export var suspension_strength := 10000.0
@export var damping_strength := 320.0
@export var rest_distance := 0.1

@export_group("Acceleration")
@export var acceleration_strength := 1000.0
@export var brake_strength := 1000.0

@export_group("")
@export var drag_coef := 0.5
@export var traction_coef := 1.0

func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		apply_force(global_basis.x * mass * 10)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		apply_force(-global_basis.x * mass * 10)
	
	for wheel in wheels:
		#DebugDraw3D.draw_arrow_ray(wheel.get_wheel_pos() + global_position, wheel.global_basis.x, 1, Color.DEEP_PINK, 0.05)
		
		handle_suspension(wheel)
		handle_acceleration(wheel)
		handle_steering(wheel)
		handle_traction(wheel)
		
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
	var length := up.dot(wheel.global_position) - up.dot(contact) - wheel_radius
	var offset := rest_distance - length
	
	if offset <= 0:
		return
	
	wheel.mesh.position.y = -length
	
	var suspension_force := suspension_strength * offset
	
	var world_vel := get_point_velocity(contact)
	var relative_vel := up.dot(world_vel)
	var damping_force := damping_strength * relative_vel
	
	var force = (suspension_force - damping_force) * up
	var force_pos := wheel.get_wheel_pos();
	
	apply_force(force, force_pos)
	DebugDraw3D.draw_arrow_ray(force_pos + global_position, force / mass, 0.3, Color.BLUE, 0.05)
	
func handle_acceleration(wheel: Wheel):
	if not wheel.is_on_ground():
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
	
	var force_pos := wheel.get_wheel_pos()
	
	apply_force(force, force_pos)
	DebugDraw3D.draw_arrow_ray(force_pos + global_position, force / mass, 0.3, Color.GREEN, 0.05)
	
	# wheel spin
	var vel := forward.dot(get_point_velocity(wheel.get_wheel_pos() + global_position))
	var ang_vel := -vel / wheel_radius
	wheel.mesh.rotate_x(ang_vel * get_physics_process_delta_time())
	
func handle_steering(wheel: Wheel):
	if not wheel.can_steer:
		return
	
	var steering_axis = Input.get_axis("steer_left", "steer_right")
	var max_steer_angle = deg_to_rad(30)
	var angle = steering_axis * max_steer_angle
	
	wheel.rotation.y = -angle
	
func handle_traction(wheel: Wheel):
	if not wheel.is_on_ground():
		return
	
	#var right := wheel.global_basis.x.rotated(wheel.global_basis.y, steering_angle) if wheel.can_steer else wheel.global_basis.x
	var right := wheel.global_basis.x
	var right_vel := right.dot(get_point_velocity(wheel.get_wheel_pos() + global_position))
	#DebugDraw3D.draw_arrow_ray(wheel.get_wheel_pos() + global_position, right * right_vel, 1, Color.DEEP_PINK, 0.05)
	
	var desired_vel_change := -right_vel * traction_coef
	var desired_acceleration := desired_vel_change / get_physics_process_delta_time()
	
	var traction_force := right * desired_acceleration * mass / 4.0
	var force_pos := wheel.get_wheel_pos()
	
	apply_force(traction_force, force_pos)
	DebugDraw3D.draw_arrow_ray(force_pos + global_position, traction_force / mass, 0.3, Color.RED, 0.05)
	
