extends Panel
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/Music_slider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SFX_slider
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	var music_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sfx_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	music_slider.value = db_to_linear(music_db)
	sfx_slider.value = db_to_linear(sfx_db)
	
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	
	
func _on_music_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

func _on_sfx_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
