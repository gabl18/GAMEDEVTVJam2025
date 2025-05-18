extends TextureRect

var drawer_is_open := false
@onready var button_drawer_open: = $Button_Drawer_Open
@onready var button_drawer_close: = $Button_Drawer_Close
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"





func _on_button_drawer_open_pressed() -> void:
	if not drawer_is_open:
		animation_player.play("Opening_Closing_Drawer")
	button_drawer_open.visible = false
	button_drawer_close.visible = true
	drawer_is_open = true


func _on_button_drawer_close_pressed() -> void:
	if drawer_is_open:
		animation_player.play_backwards("Opening_Closing_Drawer")
	button_drawer_close.visible = false
	button_drawer_open.visible = true
	drawer_is_open = false
