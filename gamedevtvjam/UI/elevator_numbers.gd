extends TextureRect
var tween: Tween

func change_number_to(number:int,number_delta:int):

	tween = self.create_tween()
	tween.tween_property(self,"texture:region:position:y",(number-1)*7,number_delta*0.3)
	
