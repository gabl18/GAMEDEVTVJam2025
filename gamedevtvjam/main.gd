extends Node2D

enum GameStates {
	building, selling
}

var active_state: GameStates

func _ready() -> void:
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"),1) # Arrow
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor2.png"),2) # Pointer
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor3.png"),3) # Hand open
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor4.png"),4) # Hand close
	await get_tree().process_frame
	gamecycle()


func gamecycle():
	active_state = GameStates.building

	%DrawerHandler.tidy_everything_away()
	%DrawerHandler.generate_new_stuff(6)
	%Gatcha_Dispenser.generate_balls(7)
	
	
	pass
