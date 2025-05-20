extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is GlobePart:
		body.modulate.a = 0.5
		body.dropable = false


func _on_body_exited(body: Node2D) -> void:
	if body is GlobePart:
		body.modulate.a = 1
		body.dropable = true
		if body.want_dropped:
			body.is_dragged = false
