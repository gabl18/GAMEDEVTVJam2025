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
		$Sprite2D.position.y = -value.get_size().y/3
		$Area2D.position.y = -value.get_size().y/3

@export var parttype: Parts

var is_dragged := false
var mouse_offset := Vector2.ZERO

var want_dropped := false
var dropable := true
var on_garbage := false
var on_table := false
var under_table := false

func _ready() -> void:
	sprite_2d.texture = texture
	$Sprite2D.position.y = -texture.get_size().y/3
	$Area2D.position.y = -texture.get_size().y/3
	
	await get_tree().process_frame
	if not under_table:
		var y = -global_position.y
		var scale_factor = -0.005 * y + 2.0
		scale = Vector2.ONE * scale_factor
	else:
		scale = Vector2.ONE * 3


func _process(_delta: float) -> void:
	
	$Area2D.scale = Vector2(1.0 / scale.x, 1.0 / scale.y)*3
	

	if is_dragged:
		var motion = (get_global_mouse_position() - mouse_offset - global_position)
		move_and_collide(motion)
		
		if not under_table:
			var y = -global_position.y
			var scale_factor = -0.005 * y + 2.0
			scale = Vector2.ONE * scale_factor
		else:
			scale = Vector2.ONE * 3



func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :

			if event.is_pressed():
				want_dropped = false
				is_dragged = true
				mouse_offset = event.global_position - global_position 
				get_viewport().set_input_as_handled()
			else:
				if dropable:
					is_dragged = false
				else:
					want_dropped = true
					
			
	
	
