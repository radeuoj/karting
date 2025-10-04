extends Node

@onready var kart: RigidBody3D = get_tree().current_scene.get_node("Kart")

func _process(_delta: float) -> void:
	ImGui.Begin("Karting")
	
	ImGui.Text("FPS: %d" % Engine.get_frames_per_second())
	ImGui.Text("Acceleration: %.2f" % Input.get_action_strength("acceleration"))
	ImGui.Text("Brake: %.2f" % Input.get_action_strength("brake"))
	ImGui.Text("Steering: %+.2f" % Input.get_axis("steer_left", "steer_right"))
	ImGui.Text("Speed: %.2f m/s (%d km/h)" % [
		kart.linear_velocity.length(),
		kart.linear_velocity.length() * 3.6,
	])
	
	ImGui.End()
