extends CharacterBody2D
class_name GatchaBall
@onready var sfx: AudioStreamPlayer = $SFX

const GLOBE_PART = preload("res://other/globe_part.tscn")
var disassemble = preload("res://Assets/Audio/SFX/disassemble.mp3")

var info: Resource
var texture: Texture2D:
	set(value):
		texture = value
		$Inside.texture = texture
var Spawn_Location: Node2D
var breakable := false

func break_apart():
	if breakable:
		sfx.stream = disassemble
		sfx.play()
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


func _mouse_enter() -> void:
	if not MouseState.moues_state == MouseState.Mouse_States.dragging:

		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor2.png"))


func _mouse_exit() -> void:
	if not MouseState.moues_state == MouseState.Mouse_States.dragging and not MouseState.Mouse_Hovers:
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"))
