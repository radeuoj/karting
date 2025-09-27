extends Node3D

var move_speed := 7.0
var sensitivity := 0.002

var mouse_delta := Vector2.ZERO
var start := 0.0
var count := 0

func _process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_dir := (basis.z * input_dir.y + basis.x * input_dir.x).normalized()
	
	position += move_dir * move_speed * delta
	
	rotation.x -= mouse_delta.y * sensitivity
	rotation.y -= mouse_delta.x * sensitivity
	mouse_delta = Vector2.ZERO
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed(): 
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
				
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_delta += event.relative
		
		
