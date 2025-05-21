extends TextureRect

@onready var tablet_animationplayer: AnimationPlayer = $Tablet_Animationplayer
@onready var parts: Node2D = $"../Background/Parts"

enum Screens {
	Home,Rating,Email,Tutorial,Settings,Credits
}

var active_screen: Screens = Screens.Home

func _on_close_button_pressed() -> void:
	tablet_animationplayer.play_backwards("Tablet_Startup")
	
	for x in parts.get_children():
		x.lock_movement = false


func _on_return_button_pressed() -> void:
	print(1)
	if active_screen == Screens.Home:
		tablet_animationplayer.play_backwards("Tablet_Startup")

		for x in parts.get_children():
			x.lock_movement = false
	
	else:
		active_screen = Screens.Home
		print('opened home')


func _on_tutorial_button_pressed() -> void:
	print("opened tutorial")
	active_screen = Screens.Tutorial


func _on_email_button_pressed() -> void:
	print("opened email")
	active_screen = Screens.Email


func _on_rating_button_pressed() -> void:
	print("opened rating")
	active_screen = Screens.Rating


func _on_credits_button_pressed() -> void:
	print("opened credits")
	active_screen = Screens.Credits


func _on_settings_button_pressed() -> void:
	print("opened settings")
	active_screen = Screens.Settings
