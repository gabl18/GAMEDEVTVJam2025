extends TextureRect

@onready var tablet_animationplayer: AnimationPlayer = $Tablet_Animationplayer
@onready var parts: Node2D = $"../Background/Parts"

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			tablet_animationplayer.play_backwards("Tablet_Startup")
			
			for x in parts.get_children():
				x.lock_movement = false
