extends TextureRect



@onready var button_drawer_open: = $Button_Drawer_Open
@onready var button_drawer_close: = $Button_Drawer_Close
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"

var drawer_is_open := false:
	set(value):
		drawer_is_open = value
		$Off_Table_Area2d/Drawer_Close_Poly.disabled = value
var layerindex := 0
var drawer_button_cooldown = false
var cover_button_cooldown = false

signal change_drawer_layer(layerindex:int)

func _on_button_drawer_open_pressed() -> void:
	if not drawer_button_cooldown:
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
	if not drawer_button_cooldown:
		if drawer_is_open:
			drawer_is_open = false
			drawer_button_cooldown = true
			animation_player.play_backwards("Opening_Closing_Cover")
			await animation_player.animation_finished
			animation_player.play_backwards("Opening_Closing_Drawer")
			drawer_button_cooldown = false
			
		button_drawer_close.visible = false
		button_drawer_open.visible = true
	


func _on_button_cover_up_pressed() -> void:
	if drawer_is_open:
		if not cover_button_cooldown:
			cover_button_cooldown = true
			layerindex += 1
			animation_player.play_backwards("Opening_Closing_Cover")
			await animation_player.animation_finished
			change_drawer_layer.emit(layerindex)
			animation_player.play("Opening_Closing_Cover")
			await animation_player.animation_finished
			cover_button_cooldown = false


func _on_button_cover_down_pressed() -> void:
	if drawer_is_open:
		if not cover_button_cooldown:
			cover_button_cooldown = true
			layerindex -= 1
			animation_player.play_backwards("Opening_Closing_Cover")
			await animation_player.animation_finished
			change_drawer_layer.emit(layerindex)
			animation_player.play("Opening_Closing_Cover")
			await animation_player.animation_finished
			cover_button_cooldown = false
