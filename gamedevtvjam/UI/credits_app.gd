extends Panel

@export var Credits: Array[String]

func _ready() -> void:
	for x in Credits:
		var new_label = %CreditsLabel.duplicate()
		if x.begins_with("https://"):
			new_label.add_theme_font_size_override("font_size",20)
		if x.begins_with("#"):
			x = x.trim_prefix("#")
			new_label.add_theme_color_override("font_color",Color("9dc1e9"))
		%CreditsLocation.add_child(new_label)
		
		new_label.text = x
		
	
