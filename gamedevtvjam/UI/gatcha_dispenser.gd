extends Area2D

const GATCHA = preload("res://other/gatcha.tscn")

var balls: Array[GatchaBall]
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if balls and $AnimationPlayer.current_animation == '':
				print(balls)
				randomize()
				var new_ball = balls[0]
				$Path2D.curve.set_point_position(2,Vector2(randf_range(720,780),randf_range(400,460)))
				$Path2D/PathFollow2D.add_child(new_ball)
				balls.pop_front()
				$Sprite2D2.visible = not balls.is_empty()
				$AnimationPlayer.play("Drop_Ball")
				await $AnimationPlayer.animation_finished
				new_ball.reparent(self)
				new_ball.breakable = true
				
func _ready() -> void:
	$Sprite2D2.visible = not balls.is_empty()

func break_all_balls():
	for child in get_children():
		if child is GatchaBall:
			child.break_apart()

func generate_balls(amount:int):
	
	for x in range(amount):
		var ball = GATCHA.instantiate()
		ball.info = Resource.new()
		ball.texture = load("res://Assets/Art/Globes/Inside/Inside2.png")
		ball.Spawn_Location = %Parts_Location
		
		balls.append(ball)
		$Sprite2D2.show()
	
	$Sprite2D2.visible = not balls.is_empty()
		
