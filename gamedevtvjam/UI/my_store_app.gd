extends Panel

signal store_open_closed_pressed

var current_rating := 5
var current_rating_amount := 0

func _ready() -> void:
	set_rating(current_rating)
	%InfoLabel.text = "you have to make enough globes first"

func set_day(daynumber:int):
	%NumberLabel.text = '#'+str(daynumber)

## set rating from 0 to 10
func set_rating(rating:int):
	rating = clamp(rating,0,10)
	%StarsTexture.texture.region.position.y = 20*(10-rating)


## set rating from 0 to 10
func add_rating(rating:int):
	current_rating_amount += 1
	
	rating = clamp(rating,0,10)
	@warning_ignore("integer_division")
	current_rating = (current_rating * current_rating_amount + rating) / (current_rating_amount+1)
	print(current_rating,current_rating_amount)
	%StarsTexture.texture.region.position.y = 20*(10-current_rating)

func unlock_btns():
	%InfoLabel.text = "press open, to start recieving customers"
	%CloseButton.disabled = false
	%OpenButton.disabled = false

func _on_open_button_toggled(toggled_on: bool) -> void:
	store_open_closed_pressed.emit()
	if toggled_on:
		%CloseButton.disabled = true
	else:
		%OpenButton.disabled = true
	
	await visibility_changed
	%InfoLabel.text = "you have to enough finished globes first"
	
		
func reset_btns():
	%CloseButton.button_pressed = true
