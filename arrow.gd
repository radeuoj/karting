extends MeshInstance3D

@export var material: Material

func _process(_delta: float) -> void:
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, material)
	
	var from := Vector3.ZERO
	var to := Vector3(0, 2, 0)
	var dir := (to - from).normalized()
	var right := dir.cross(Vector3.UP)
	if right == Vector3.ZERO: right = Vector3.RIGHT
	var up := dir.cross(right)
	var width := 0.1
	var length := (to - from).length()
	
	var bl := from - right * width - up * width
	var br := from + right * width - up * width
	var tl := from - right * width + up * width
	var tra := from + right * width + up * width
	
	var dbl := bl + dir * length
	var dbr := br + dir * length
	var dtl := tl + dir * length
	var dtr := tra + dir * length
	
	draw_rect(bl, dbl, dbr, br)
	
	#draw_rect(
		#Vector3(-1, -1, -1),
		#Vector3(-1, 1, -1),
		#Vector3(-1, 1, 1),
		#Vector3(-1, -1, 1),
	#)

	mesh.surface_end()
	
func draw_line(from: Vector3, to: Vector3):
	mesh.surface_add_vertex(from)
	mesh.surface_add_vertex(to)

func draw_rect(bl: Vector3, tl: Vector3, tra: Vector3, br: Vector3):
	mesh.surface_add_vertex(bl)
	mesh.surface_add_vertex(tl)
	mesh.surface_add_vertex(tra)
	
	mesh.surface_add_vertex(tra)
	mesh.surface_add_vertex(br)
	mesh.surface_add_vertex(bl)
