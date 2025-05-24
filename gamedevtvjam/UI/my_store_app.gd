extends Panel

signal store_open_closed_pressed

func set_day(daynumber:int):
	%NumberLabel.text = '#'+str(daynumber)

## set rating from 0 to 10
func set_rating(rating:int):
	rating = clamp(rating,0,10)
	%StarsTexture.texture.region.position.y = 20*(10-rating)

func unlock_btns():
	%CloseButton.disabled = false
	%OpenButton.disabled = false

func _on_open_button_toggled(toggled_on: bool) -> void:
	store_open_closed_pressed.emit()
	if toggled_on:
		%CloseButton.disabled = true
	else:
		%OpenButton.disabled = true
