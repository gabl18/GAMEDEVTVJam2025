extends CharacterBody2D
class_name AssemblyGlobe
@onready var sfx: AudioStreamPlayer = $SFX

const GLOBE_PART = preload("res://other/globe_part.tscn")
var disassemble = preload("res://Assets/Audio/SFX/disassemble.mp3")
var assemble = preload("res://Assets/Audio/SFX/assemble.mp3")

enum Parts {
	Globe,
	Base,
	Inside
}

var owned_parts: Dictionary={
	Parts.Base:null,
	Parts.Globe:null,
	Parts.Inside:null
}

var part_sequence: Array[Parts] = [
	Parts.Base,Parts.Globe,Parts.Inside
]

@onready var base: Sprite2D = $Base
@onready var inside: Sprite2D = $Inside
@onready var globe: Sprite2D = $Globe


@onready var part_sprites: Dictionary[Parts,Sprite2D] = {
	Parts.Base:base,
	Parts.Globe:globe,
	Parts.Inside:inside
}

var is_dragged := false:
	set(value):
		is_dragged = value
		MouseState.moues_state = MouseState.Mouse_States.idle
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"))
		
var mouse_offset := Vector2.ZERO
var in_drawer := false

var want_dropped := false
var dropable := true

var lock_movement := false

func _ready() -> void:
	await get_tree().process_frame

	var y = -global_position.y
	var scale_factor = -0.005 * y + 2.0
	scale = Vector2.ONE * scale_factor

func _process(_delta: float) -> void:
	if not lock_movement:
		$Area2D.scale = Vector2(1.0 / scale.x, 1.0 / scale.y)*3
		$Merge_Area2D.scale = Vector2(1.0 / scale.x, 1.0 / scale.y)*3

		if is_dragged:
			var motion = (get_global_mouse_position() - mouse_offset - global_position)
			move_and_collide(motion)

			var y = -global_position.y
			var scale_factor = -0.005 * y + 2.0
			scale = Vector2.ONE * scale_factor
			
func _mouse_enter() -> void:
	MouseState.Mouse_Hovers.append(self)
	if not MouseState.moues_state == MouseState.Mouse_States.dragging:

		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor3.png"))


func _mouse_exit() -> void:
	MouseState.Mouse_Hovers.erase(self)
	if not MouseState.moues_state == MouseState.Mouse_States.dragging and not MouseState.Mouse_Hovers:
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"))
		
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not lock_movement:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.is_pressed():
					
					var x = remove_part()
					if x:
						get_parent().add_child(x)
					
					get_viewport().set_input_as_handled()


			elif event.button_index == MOUSE_BUTTON_LEFT:
				
				if event.is_pressed():
					want_dropped = false
					is_dragged = true
					mouse_offset = event.global_position - global_position 
					get_viewport().set_input_as_handled()
					
					MouseState.moues_state = MouseState.Mouse_States.dragging
					Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor4.png"))
				
				else:
					if dropable:
						is_dragged = false
					else:
						want_dropped = true
						

func check_part(part: GlobePart) -> bool:
	return owned_parts.get(part.parttype) == null


func add_part(part:GlobePart) -> GlobePart:
	var y = -global_position.y
	var scale_factor = -0.005 * y + 2.0
	scale = Vector2.ONE * scale_factor
	if owned_parts.get(part.parttype) == null:
		sfx.stream = assemble
		sfx.play()
		owned_parts.set(part.parttype,part.info)
		part_sprites[part.parttype].texture = part.texture
		MouseState.Mouse_Hovers.erase(part)
		part.queue_free()
		
		return null
	else: return part

func remove_part() -> GlobePart:
	sfx.stream = disassemble
	sfx.play()
	for i in range(part_sequence.size()-1, -1, -1): #why the fuck is there no reverse()
		if owned_parts.get(part_sequence[i]) != null:
			var new_part = GLOBE_PART.instantiate()
			new_part.parttype = part_sequence[i]
			new_part.texture = part_sprites[part_sequence[i]].texture
			new_part.info = owned_parts.get(part_sequence[i])
			new_part.global_position = global_position
			
			part_sprites[part_sequence[i]].texture = null
			owned_parts[part_sequence[i]] = null
			
			
			if owned_parts.values().filter(func(v):return v != null).size() == 1:
				
				var new_part2 = GLOBE_PART.instantiate()
				new_part2.parttype = Parts.Base
				new_part2.texture = part_sprites[Parts.Base].texture
				new_part2.info = owned_parts.get(Parts.Base)
				new_part2.global_position = global_position
				get_parent().add_child(new_part2)
				MouseState.Mouse_Hovers.erase(self)
				self.queue_free()
			
			return new_part
	
	return null
