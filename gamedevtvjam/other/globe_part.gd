@tool
extends CharacterBody2D
class_name GlobePart

enum Parts {
	Globe,
	Base,
	Inside
}

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var texture: Texture2D:
	set(value):
		texture = value
		$Sprite2D.texture = value
		
@export var part: Parts

var is_dragged := false
var mouse_offset := Vector2.ZERO

var want_dropped := false
var dropable := true

func _ready() -> void:
	sprite_2d.texture = texture
	
	var y = -global_position.y
	var scale_factor = -0.005 * y + 2.0
	scale = Vector2.ONE * scale_factor


func _process(_delta: float) -> void:
	if is_dragged:
		var motion = (get_global_mouse_position() - mouse_offset - global_position)
		move_and_collide(motion)
		
		var y = -global_position.y
		var scale_factor = -0.005 * y + 2.0
		scale = Vector2.ONE * scale_factor


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		
		if event.is_pressed():
			want_dropped = false
			is_dragged = true
			mouse_offset = event.global_position - global_position 
		else:
			if dropable:
				is_dragged = false
			else:
				want_dropped = true
