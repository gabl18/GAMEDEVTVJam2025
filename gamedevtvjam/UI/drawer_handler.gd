extends Node

@export var drawer_collision_polygon: CollisionPolygon2D
@export var globe_collision_polygon: CollisionPolygon2D

@export var parts_location: Node2D

const GLOBE_PART = preload("res://other/globe_part.tscn")

var layer_1: Array[GlobePart]
var layer_2: Array[GlobePart]
var layer_3: Array[GlobePart]
var layer_4: Array[GlobePart]
var layers = [layer_1,layer_2,layer_3,layer_4]

var active_layer = 0
var opened = false:
	set(value):
		opened = value
		generate_new_stuff(1)
		
func _ready() -> void:
	randomize()

func _on_drawer_area_2d_area_entered(area: Area2D) -> void:
	if opened:
		if area.get_parent() is GlobePart:
			if not area.get_parent().in_drawer:
			
				layers[active_layer].append(area.get_parent())
				
				area.get_parent().z_index = 0
				area.get_parent().no_merge = true


func _on_drawer_area_2d_area_exited(area: Area2D) -> void:
	if opened:
		if area.get_parent() is GlobePart:
			layers[active_layer].erase(area.get_parent())
			
			area.get_parent().z_index = 1
			area.get_parent().no_merge = false
			area.get_parent().in_drawer = false


func _on_texture_rect_changed_drawer_layer(value: int) -> void:
	if wrapi(active_layer + value, 0, layers.size()) != active_layer:
		var scuffed = active_layer
		active_layer = wrapi(active_layer + value, 0, layers.size())
		show_layer(active_layer)
		#await get_tree().create_timer(0.25).timeout
		hide_layer(scuffed)


func _on_texture_rect_drawer_opened_closed(open: bool) -> void:
	opened = open
	if opened:
		show_layer(active_layer)
	else:
		await get_tree().create_timer(0.25).timeout
		hide_layer(active_layer)


func show_layer(layerindex: int):
	for body in layers[layerindex]:
		body.visible = true
		body.sleep = false


func hide_layer(layerindex: int):
	for body in layers[layerindex]:
		body.visible = false
		body.sleep = true


func generate_new_stuff(globe_amount:int):
	
	var points := get_random_points_in_polygon(drawer_collision_polygon.polygon,globe_amount + 1,20.0)

	for x in range(globe_amount + 1):
		var new_part = GLOBE_PART.instantiate()
		new_part.global_position = points.pick_random()
		points.erase(new_part.global_position)
		new_part.parttype = new_part.Parts.Globe
		new_part.texture = load("res://Assets/Art/Globes/Globe/Globe1.png")
		
		layers[0].append(new_part)
		new_part.z_index = 0
		new_part.in_drawer = true
		new_part.sleep = true
		new_part.no_merge = true
		new_part.under_table = true
		new_part.scale = Vector2.ONE * 3
		parts_location.add_child(new_part)
	hide_layer(0)
	points = get_random_points_in_polygon(drawer_collision_polygon.polygon,globe_amount + 1,20.0)

	for x in range(globe_amount + 1):
		var new_part = GLOBE_PART.instantiate()
		new_part.global_position = points.pick_random()
		points.erase(new_part.global_position)
		new_part.parttype = new_part.Parts.Base
		new_part.texture = load("res://Assets/Art/Globes/Base/Base1.png")
		
		layers[1].append(new_part)
		new_part.z_index = 0
		new_part.in_drawer = true
		new_part.sleep = true
		new_part.no_merge = true
		new_part.under_table = true
		new_part.scale = Vector2.ONE * 3
		parts_location.add_child(new_part)
	hide_layer(1)

func tidy_everything_away():
	var layer_points: Array[Array]
	var globe_points := get_random_points_in_polygon(globe_collision_polygon.polygon,6,50.0)
	for layer in layers:
		layer_points.append(get_random_points_in_polygon(drawer_collision_polygon.polygon,15,20.0))
		
	for body in parts_location.get_children():
		if body is AssemblyGlobe:
			body.global_position = globe_points.pick_random()
			globe_points.erase(body.global_position)
			var y = -body.global_position.y
			var scale_factor = -0.005 * y + 2.0
			body.scale = Vector2.ONE * scale_factor
			continue
			
		if body.in_drawer: continue
		
		if body is GlobePart:
			body.in_drawer = true
			var x:int
			match body.parttype:
				body.Parts.Globe:
					body.global_position = layer_points[0].pick_random()
					layer_points[0].erase(body.global_position)
					x = 0
					
				body.Parts.Base:
					body.global_position = layer_points[1].pick_random()
					layer_points[0].erase(body.global_position)
					x = 1
					
				body.Parts.Inside:
					body.global_position = layer_points[2].pick_random()
					layer_points[0].erase(body.global_position)
					x = 2

			layers[x].append(body)
			body.z_index = 0
			body.no_merge = true
			body.scale = Vector2.ONE * 3
	
	for x in range(0, layers.size()):
		hide_layer(x)

func get_random_points_in_polygon(polygon: PackedVector2Array, count: int, min_distance: float, max_attempts := 1000) -> Array:
	var points := []
	var attempts := 0

	while points.size() < count and attempts < max_attempts:
		var p = get_random_point_in_polygon(polygon)

		var too_close := false
		for existing in points:
			if existing.distance_to(p) < min_distance:
				too_close = true
				break

		if not too_close:
			points.append(p)

		attempts += 1

	if points.size() < count:
		print("Warning: Only generated %d points out of %d requested." % [points.size(), count])

	return points

func get_random_point_in_polygon(polygon: PackedVector2Array) -> Vector2:
	var indices = Geometry2D.triangulate_polygon(polygon)
	if indices.size() < 3:
		push_error("Invalid polygon")
		return Vector2.ZERO

	@warning_ignore("integer_division")
	var triangle_count = indices.size() / 3
	var tri_index = randi() % triangle_count

	var i0 = indices[tri_index * 3]
	var i1 = indices[tri_index * 3 + 1]
	var i2 = indices[tri_index * 3 + 2]

	return random_point_in_triangle(polygon[i0], polygon[i1], polygon[i2])

func random_point_in_triangle(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	var r1 = randf()
	var r2 = randf()
	if r1 + r2 >= 1.0:
		r1 = 1.0 - r1
		r2 = 1.0 - r2
	return a + (b - a) * r1 + (c - a) * r2
