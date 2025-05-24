extends Area2D

const GATCHA = preload("res://other/gatcha.tscn")
@onready var sfx: AudioStreamPlayer = $"../../../SFX"

var balls: Array[GatchaBall]
var lever = preload("res://Assets/Audio/SFX/lever.mp3")

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if balls and $AnimationPlayer.current_animation == '':
				sfx.stream = lever
				sfx.play()
				print(balls)
				var disassemble = preload("res://Assets/Audio/SFX/disassemble.mp3")
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

func generate_balls(amount:int):
	
	for x in range(amount):
		var ball = GATCHA.instantiate()
		ball.info = Resource.new()
		ball.texture = load("res://Assets/Art/Globes/Inside/Inside2.png")
		ball.Spawn_Location = %Parts_Location
		
		balls.append(ball)
		$Sprite2D2.show()
	
	$Sprite2D2.visible = not balls.is_empty()
		
