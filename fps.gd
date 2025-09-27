extends Label

@export var kart: RigidBody3D

func _process(_delta: float) -> void:
	text = "FPS: %d\nAcceleration: %.2f\nBrake: %.2f\nSteering: %+.2f\nSpeed: %.2f m/s (%d km/h)" % [
		Engine.get_frames_per_second(), 
		Input.get_action_strength("acceleration"),
		Input.get_action_strength("brake"),
		Input.get_axis("steer_left", "steer_right"),
		kart.linear_velocity.length(),
		kart.linear_velocity.length() * 3.6,
	]
