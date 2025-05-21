extends CharacterBody2D
class_name GatchaBall

const GLOBE_PART = preload("res://other/globe_part.tscn")

var info: Resource
var texture: Texture2D:
	set(value):
		texture = value
		$Inside.texture = texture
var Spawn_Location: Node2D
var breakable := false

func break_apart():
	if breakable:
		breakable = false
		var new_part = GLOBE_PART.instantiate()
		new_part.global_position = global_position
		new_part.parttype = GlobePart.Parts.Inside
		new_part.texture = texture
		var y = -new_part.global_position.y
		var scale_factor = -0.005 * y + 2.0
		new_part.scale = Vector2.ONE * scale_factor
		
		$Inside.hide()
		Spawn_Location.add_child(new_part)
		$AnimationPlayer.play("Fade_Out")
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		break_apart()
