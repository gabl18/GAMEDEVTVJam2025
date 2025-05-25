extends Panel

@export var Credits: Array[String]

func _ready() -> void:
	for x in Credits:
		var new_label = %CreditsLabel.duplicate()
		
		%CreditsLocation.add_child(new_label)
		
		new_label.text = x
