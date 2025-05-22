@tool
extends CharacterBody2D
class_name GlobePart

const ASSEMBLY_GLOBE = preload("res://other/assembly_globe.tscn")

enum Parts {
	Globe,
	Base,
	Inside
}

const parts_colliders :={
	Parts.Inside:preload("res://other/colliders/inside_collider.tres"),
	Parts.Globe:preload("res://other/colliders/globe_collider.tres"),
	Parts.Base:preload("res://other/colliders/base_collider.tres")
}

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var texture: Texture2D:
	set(value):
		texture = value
		$Sprite2D.texture = value
		$Sprite2D.position.y = -value.get_size().y/3
		$Area2D.position.y = -value.get_size().y/3
		var y = -global_position.y
		var scale_factor = -0.005 * y + 2.0
		scale = Vector2.ONE * scale_factor

@export var parttype: Parts

@export var info: Resource

var is_dragged := false:
	set(value):
		is_dragged = value
		
		if is_dragged == false:
			try_merge()
			MouseState.moues_state = MouseState.Mouse_States.idle
			Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor3.png"))

var mouse_offset := Vector2.ZERO

var want_dropped := false
var dropable := true
var on_garbage := false
var on_table := false
var under_table := false
var lock_movement := false
var sleep := false:
	set(value):
		sleep = value
		$Merge_Area2D.monitorable = not sleep
var no_merge := false:
	set(value):
		no_merge = value
		$Merge_Area2D.set_deferred("monitorable",not no_merge)
var in_drawer := false

var merge_bodies : Array[CharacterBody2D]
var closest_merge_body : CharacterBody2D


func _ready() -> void:
	sprite_2d.texture = texture
	$Sprite2D.position.y = -texture.get_size().y/3
	$Area2D.position.y = -texture.get_size().y/3
	$Merge_Area2D.position.y = -texture.get_size().y/3
	$CollisionShape2D.position.y = -texture.get_size().y/3
	$CollisionShape2D.shape = parts_colliders[parttype]
	
	await get_tree().process_frame
	if not under_table:
		var y = -global_position.y
		var scale_factor = -0.005 * y + 2.0
		scale = Vector2.ONE * scale_factor
	else:
		scale = Vector2.ONE * 3


func _process(_delta: float) -> void:
	if not lock_movement and not sleep:
		$Area2D.scale = Vector2(1.0 / scale.x, 1.0 / scale.y)*3
		$Merge_Area2D.scale = Vector2(1.0 / scale.x, 1.0 / scale.y)*3

		if is_dragged:
			var motion = (get_global_mouse_position() - mouse_offset - global_position)
			move_and_collide(motion)
			if merge_bodies:
				colorin_closest_body()
			
			if not under_table:
				var y = -global_position.y
				var scale_factor = -0.005 * y + 2.0
				scale = Vector2.ONE * scale_factor
			else:
				scale = Vector2.ONE * 3


func _mouse_enter() -> void:
	print(12)
	MouseState.Mouse_Hovers.append(self)
	if not MouseState.moues_state == MouseState.Mouse_States.dragging:
		print(13)
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor3.png"))


func _mouse_exit() -> void:
	MouseState.Mouse_Hovers.erase(self)
	if not MouseState.moues_state == MouseState.Mouse_States.dragging and not MouseState.Mouse_Hovers:
		print(23)
		Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"))


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	
	if not lock_movement and not sleep:

			
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

			if event.is_pressed():
				want_dropped = false
				is_dragged = true
				mouse_offset = event.global_position - global_position 
				get_viewport().set_input_as_handled()
				
				for area in $Merge_Area2D.get_overlapping_areas():
					check_for_merging(area)
				MouseState.moues_state = MouseState.Mouse_States.dragging
				Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor4.png"))
					
			else:
				if dropable:
					is_dragged = false
				else:
					want_dropped = true


func _on_merge_area_2d_area_entered(area: Area2D) -> void:

	check_for_merging(area)


func _on_merge_area_2d_area_exited(area: Area2D) -> void:

	var body = area.get_parent()
	if body in merge_bodies:
		merge_bodies.erase(body)
		if merge_bodies.is_empty():
			modulate.r = 1
			modulate.b = 1
			body.modulate.r = 1
			body.modulate.b = 1
			closest_merge_body = null


func check_for_merging(area: Area2D):

	if is_dragged:
		var body = area.get_parent()
		if body is GlobePart:
			if parttype == Parts.Base and body.parttype == Parts.Globe or parttype == Parts.Globe and body.parttype == Parts.Base:
				
				merge_bodies.append(body)
				colorin_closest_body()
				
				modulate.r = 0.5
				modulate.b = 0.5
		
		elif body is AssemblyGlobe:
			if body.check_part(self):
				
				merge_bodies.append(body)
				colorin_closest_body()

				modulate.r = 0.5
				modulate.b = 0.5

func colorin_closest_body():
	if closest_merge_body:
		closest_merge_body.modulate.r = 1
		closest_merge_body.modulate.b = 1
	closest_merge_body = get_closest_body(global_position, merge_bodies)
	closest_merge_body.modulate.r = 0.5
	closest_merge_body.modulate.b = 0.5

func get_closest_body(position_: Vector2, bodies: Array) -> Node2D:
	var closest_body = null
	var closest_distance = INF

	for body in bodies:
		var distance = position_.distance_to(body.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_body = body

	return closest_body

func try_merge():
	if closest_merge_body:
		closest_merge_body.modulate.r = 1
		closest_merge_body.modulate.b = 1
		if closest_merge_body is GlobePart:
			var new_Globe = ASSEMBLY_GLOBE.instantiate()
			get_parent().add_child(new_Globe)
			new_Globe.global_position = closest_merge_body.global_position
			new_Globe.add_part(self)
			new_Globe.add_part(closest_merge_body)
		
		elif closest_merge_body is AssemblyGlobe:
			closest_merge_body.add_part(self)
		
