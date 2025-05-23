extends HSlider

func _value_changed(new_value: float) -> void:
	$"../HBoxContainer/MarginContainer".size_flags_stretch_ratio = new_value/50
