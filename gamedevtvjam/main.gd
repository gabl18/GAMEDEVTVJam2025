extends Node2D

enum GameStates {
	building, selling
}
const EXAMPLE_BALLOON = preload("res://UI/example_balloon.tscn")

var active_state: GameStates

@export var people: Array[Person]
var taken_people: Array[Person]

var active_person: Person
var is_dialogue_active: bool

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_dialogue_started)
	DialogueManager.dialogue_ended.connect(_dialogue_ended)
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor1.png"),1) # Arrow
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor2.png"),2) # Pointer
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor3.png"),3) # Hand open
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	Input.set_custom_mouse_cursor(load("res://Assets/Art/cursors/cursor4.png"),4) # Hand close
	await get_tree().process_frame
	gamecycle()


func gamecycle():
	active_state = GameStates.building
	
	%DrawerHandler.lock_drawer = false
	%Background.lock_drawer = false
	%People.visible = false
	%DrawerHandler.tidy_everything_away()
	%DrawerHandler.generate_new_stuff(6)
	%Gatcha_Dispenser.generate_balls(7)
	
	await %myStoreApp.store_open_pressed
	
	
	# -------------------------------
	active_state = GameStates.selling
	%Gatcha_Dispenser.break_all_balls()
	%DrawerHandler.tidy_everything_away()
	%DrawerHandler.lock_drawer = true
	%Background.lock_drawer = true
	active_person = people.pick_random()
	people.erase(active_person)
	taken_people.append(active_person)
	
	%People.texture = active_person.texture
	%People.visible = true
	%EmailApp.send_email(load("res://people/mails/testmail1.tres"))
	#DialogueManager.show_dialogue_balloon_scene(EXAMPLE_BALLOON,load(active_person.dialogue),"start")
	

func _dialogue_started(__):
	is_dialogue_active = true
	
func _dialogue_ended(__):
	is_dialogue_active = false
	
func _on_talk_button_pressed() -> void:
	if active_state == GameStates.selling:
		if not is_dialogue_active:
			DialogueManager.show_dialogue_balloon_scene(EXAMPLE_BALLOON,load(active_person.dialogue),"start")
