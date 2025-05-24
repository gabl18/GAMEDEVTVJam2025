extends TextureRect

@onready var tablet_animationplayer: AnimationPlayer = $Tablet_Animationplayer
@onready var parts: Node2D = %Parts_Location

@onready var email_app: Panel = $Apps/EmailApp

@onready var apps: Array= [email_app]
@onready var sfx: AudioStreamPlayer = $"../../SFX"
var click = preload("res://Assets/Audio/SFX/click.mp3")
var close = preload("res://Assets/Audio/SFX/close.mp3")
	
enum Screens {
	Home,Rating,Email,Tutorial,Settings,Credits
}

var active_screen: Screens = Screens.Home

func _ready() -> void:
	_hide_all_apps()

func _on_close_button_pressed() -> void:
	sfx.stream = close
	sfx.play()
	tablet_animationplayer.play_backwards("Tablet_Startup")
	
	for x in parts.get_children():
		x.lock_movement = false


func _on_return_button_pressed() -> void:
	sfx.stream = close
	sfx.play()
	if active_screen == Screens.Home:
		tablet_animationplayer.play_backwards("Tablet_Startup")

		for x in parts.get_children():
			x.lock_movement = false
	
	else:
		active_screen = Screens.Home
		print('opened home')
		_hide_all_apps()


func _on_tutorial_button_pressed() -> void:
	sfx.stream = click
	sfx.play()
	print("opened tutorial")
	active_screen = Screens.Tutorial


func _on_email_button_pressed() -> void:
	sfx.stream = click
	sfx.play()
	active_screen = Screens.Email
	_hide_all_apps()
	email_app.show()


func _on_rating_button_pressed() -> void:
	sfx.stream = click
	sfx.play()
	print("opened rating")
	active_screen = Screens.Rating


func _on_credits_button_pressed() -> void:
	sfx.stream = click
	sfx.play()
	print("opened credits")
	active_screen = Screens.Credits


func _on_settings_button_pressed() -> void:
	sfx.stream = click
	sfx.play()
	print("opened settings")
	active_screen = Screens.Settings


func _on_closing_button_pressed() -> void:
	sfx.stream = click
	sfx.play()
	active_screen = Screens.Home
	_hide_all_apps()
	print('opened home')

func _hide_all_apps():
	for x in apps:
		x.hide()
