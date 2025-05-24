extends Panel

signal store_open_pressed

func _on_button_pressed() -> void:
	store_open_pressed.emit()
