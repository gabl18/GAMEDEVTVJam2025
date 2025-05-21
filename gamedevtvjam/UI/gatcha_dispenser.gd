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
				if balls.is_empty():
					$Sprite2D2.hide()
				$AnimationPlayer.play("Drop_Ball")
				await $AnimationPlayer.animation_finished
				new_ball.reparent(self)
				new_ball.breakable = true


func _ready() -> void:
	generate_balls(4)

func generate_balls(amount:int):
	
	for x in range(amount):
		var ball = GATCHA.instantiate()
		ball.info = Resource.new()
		ball.texture = load("res://Assets/Art/Globes/Inside/Inside2.png")
		ball.Spawn_Location = $"../Parts"
		
		balls.append(ball)
		$Sprite2D2.show()
		
