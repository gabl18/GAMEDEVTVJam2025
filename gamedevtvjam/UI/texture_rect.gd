extends TextureRect

@onready var button_drawer_open: = $Button_Drawer_Open
@onready var button_drawer_close: = $Button_Drawer_Close
@onready var animation_player: AnimationPlayer = $Desk_AnimationPlayer
@onready var sfx: AudioStreamPlayer = $"../../SFX"

var open_drawer = preload("res://Assets/Audio/SFX/drawer-open.mp3")
var change_drawer = preload("res://Assets/Audio/SFX/drawer-change.mp3")
var button_drawer = preload("res://Assets/Audio/SFX/drawer-button.mp3")


var drawer_is_open := false:
	set(value):
		drawer_is_open = value
		drawer_opened_closed.emit(value)
		if value:
			await get_tree().create_timer(0.25).timeout
			$Off_Table_Area2d/Drawer_Close_Poly.disabled = true
		else:$Off_Table_Area2d/Drawer_Close_Poly.disabled = false
		

var drawer_button_cooldown = false
var cover_button_cooldown = false

signal changed_drawer_layer(value:int)
signal drawer_opened_closed(open:bool)

var lock_drawer := false:
	set(value):
		_on_button_drawer_close_pressed()
		lock_drawer = value

func _on_button_drawer_open_pressed() -> void:
	if not lock_drawer:
		if not drawer_button_cooldown:
			sfx.stream = open_drawer
			sfx.play()
			if not drawer_is_open:
				drawer_button_cooldown = true
				animation_player.play("Opening_Closing_Drawer")
				await animation_player.animation_finished
				animation_player.play("Opening_Closing_Cover")
				drawer_is_open = true
				drawer_button_cooldown = false
				
			button_drawer_open.visible = false
			button_drawer_close.visible = true
	


func _on_button_drawer_close_pressed() -> void:
	if not lock_drawer:
		if not drawer_button_cooldown:
			if drawer_is_open:
				sfx.stream = open_drawer
				sfx.play()
				drawer_is_open = false
				drawer_button_cooldown = true
				animation_player.play_backwards("Opening_Closing_Cover")
				await animation_player.animation_finished
				animation_player.play_backwards("Opening_Closing_Drawer")
				drawer_button_cooldown = false
				
			button_drawer_close.visible = false
			button_drawer_open.visible = true
	


func _on_button_cover_up_pressed() -> void:
	if not lock_drawer:
		if drawer_is_open:
			if not cover_button_cooldown:
				sfx.stream = change_drawer
				sfx.play()
				cover_button_cooldown = true
				animation_player.play_backwards("Opening_Closing_Cover")
				await animation_player.animation_finished
				changed_drawer_layer.emit(-1)
				animation_player.play("Opening_Closing_Cover")
				await animation_player.animation_finished
				cover_button_cooldown = false


func _on_button_cover_down_pressed() -> void:
	if not lock_drawer:
		if drawer_is_open:
			if not cover_button_cooldown:
				sfx.stream = change_drawer
				sfx.play()
				cover_button_cooldown = true
				animation_player.play_backwards("Opening_Closing_Cover")
				await animation_player.animation_finished
				changed_drawer_layer.emit(1)
				animation_player.play("Opening_Closing_Cover")
				await animation_player.animation_finished
				cover_button_cooldown = false
