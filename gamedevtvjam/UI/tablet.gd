extends Area2D


@export var tablet_animation_player: AnimationPlayer
@onready var parts: Node2D = $"../Parts"

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			tablet_animation_player.play("Tablet_Startup")
			for x in parts.get_children():
				x.lock_movement = true
