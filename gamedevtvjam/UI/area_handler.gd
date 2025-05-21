extends Node


func _on_table_area_2d_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.on_table = true


func _on_table_area_2d_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.on_table = false


func _on_off_table_area_2d_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.modulate.a = 0.3
		body.dropable = false


func _on_off_table_area_2d_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.modulate.a = 1
		body.dropable = true
		if body.want_dropped:
			body.is_dragged = false


func _on_garbage_area_2d_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.on_garbage = true
		body.modulate.b = 0
		body.modulate.g = 0


func _on_garbage_area_2d_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.on_garbage = false
		body.modulate.b = 1
		body.modulate.g = 1


func _on_above_table_area_2d_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.under_table = false


func _on_above_table_area_2d_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body is GlobePart:
		body.under_table = true


func _on_off_table_area_2d_globes_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is AssemblyGlobe:
		body.modulate.a = 0.3
		body.dropable = false



func _on_off_table_area_2d_globes_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body is AssemblyGlobe:
		body.modulate.a = 1
		body.dropable = true
		if body.want_dropped:
			body.is_dragged = false
