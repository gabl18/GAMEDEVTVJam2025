extends Area2D

@export var tablet_animation_player: AnimationPlayer
@onready var parts: Node2D = %Parts_Location
@onready var sfx: AudioStreamPlayer = $"../../../SFX"
var startup = preload("res://Assets/Audio/SFX/close.mp3")

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			sfx.stream = startup
			sfx.play()
			tablet_animation_player.play("Tablet_Startup")
			for x in parts.get_children():
				x.lock_movement = true

func _mouse_enter() -> void:
	if not MouseState.moues_state == MouseState.Mouse_States.dragging:
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor2.png"))
	
func _mouse_exit() -> void:
	if not MouseState.moues_state == MouseState.Mouse_States.dragging:
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"))
