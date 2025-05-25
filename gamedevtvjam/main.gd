extends Node2D

enum GameStates {
	building, selling
}

const EXAMPLE_BALLOON = preload("res://UI/example_balloon.tscn")


@export var people: Array[Person]
@export var day_people_numbers: Array[int]
@export var globe_parts: Array[GlobePartRes]

var globe_parts_base: Array[GlobePartRes]
var globe_parts_inside: Array[GlobePartRes]
var globe_parts_globe: Array[GlobePartRes]

var active_state: GameStates
var taken_people: Array[Person]
var active_person: Person
var is_dialogue_active: bool
var passed_days := 0

var all_objects: Array
var all_parts: Array[GlobePart]
var all_globes: Array[AssemblyGlobe]
var finished_globes: Array[AssemblyGlobe]

@onready var sfx: AudioStreamPlayer = $SFX
@onready var music: AudioStreamPlayer = $Music

var hello = preload("res://Assets/Audio/SFX/hello-81683.mp3")
var done = preload("res://Assets/Audio/SFX/notification.mp3")

signal _enough_globes_done
signal _sold_globe(globe)

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
	
	for part in globe_parts:
		match part.type:
			0:
				globe_parts_globe.append(part)
			1:
				globe_parts_base.append(part)
			2:
				globe_parts_inside.append(part)
	
	prepare_game()
	gamecycle()
	
var all_people: Array
var all_mails: Array

func prepare_game():
	for day in range(day_people_numbers.size()):
		var todays_mails: Array[EmailRes]
		var _todays_people: Array[Person]
		while _todays_people.size() < day_people_numbers[day]:
			var person: Person = people.pick_random()
			
			
			if day == 4:
				person = load("res://People/botrizz.tres")
				person.emails.shuffle()
				for mail in person.emails:
					if person.emails.find(mail) == 0:
						todays_mails.append(mail)
					else:
						all_mails[person.emails.find(mail)-1].append(mail)
					people.erase(person)
					taken_people.append(person)
					_todays_people.append(person)
					continue
			
			if person.only_after:
				if person.only_after not in taken_people:
					continue
			
			if person.earliest_day:
				if person.earliest_day > day:
					continue
			
			if person.latest_day:
				if person.latest_day < day:
					continue
			
			var tries = 10
			while tries > 0:
				var mail: EmailRes = person.emails.pick_random()
				
				if mail.days_earlier == 0:
					todays_mails.append(mail)
					break
				else:
					if all_mails.size() >= abs(mail.days_earlier):
						all_mails[all_mails.size() + mail.days_earlier].append(mail)
						break
						
				tries -= 1
				
			if tries == 0:
				continue
			
			people.erase(person)
			taken_people.append(person)
			_todays_people.append(person)
				
		all_people.append(_todays_people)
		all_mails.append(todays_mails)

var todays_people
func gamecycle():
	randomize()
	##get all the people for the day
	todays_people = all_people[passed_days]
	var todays_mails = all_mails[passed_days]
	
	##send all the emails
	todays_mails.shuffle()
	for mail in todays_mails:
		%EmailApp.send_email(mail)
	
	## increment the day
	passed_days += 1
	%myStoreApp.set_day(passed_days)

	##------------------------------------------
	active_state = GameStates.building
	
	## building part of the day
	%Building_Poly.disabled = false
	%Gatcha_Dispenser.locked = false
	%DrawerHandler.lock_drawer = false
	%Background.lock_drawer = false
	%People.visible = false
	%DrawerHandler.tidy_everything_away()
	
	var todays_bases = pick_random_unique_elements(globe_parts_base, todays_people.size()+2)
	var todays_insides = pick_random_unique_elements(globe_parts_inside, todays_people.size()+3)
	var todays_globes: Array[GlobePartRes]
	for x in range(todays_people.size()):
		todays_globes.append(globe_parts_globe.pick_random())

	%DrawerHandler.generate_new_stuff(todays_globes,todays_bases)
	%Gatcha_Dispenser.generate_balls(todays_insides)
	
	await self._enough_globes_done
	%myStoreApp.unlock_btns()
	
	## GABL: sound effect when you have made enough globes
	sfx.stream = done
	sfx.play()
	
	await %myStoreApp.store_open_closed_pressed

	## selling part of the day
	## -------------------------------
	
	active_state = GameStates.selling
	%Gatcha_Dispenser.locked = true
	%Gatcha_Dispenser.break_all_balls()
	%DrawerHandler.tidy_everything_away()
	%DrawerHandler.lock_drawer = true
	%Background.lock_drawer = true
	
	for person in todays_people:
		# screen blackout
		active_person = person
		%People.texture = active_person.texture
		%People.visible = true
		
		await DialogueManager.dialogue_started
		await DialogueManager.dialogue_ended
		
		%Building_Poly.disabled = true
		
		await _sold_globe
		
		print('sold')
		%Building_Poly.disabled = false
		
		var rating = rate_globe(active_person,selling_globe)
		
		DialogueManager.show_dialogue_balloon_scene(EXAMPLE_BALLOON,load(active_person.dialogue),"bye")
		
		selling_globe.queue_free()
		finished_globes.erase(selling_globe)
		selling_globe = null
		
		await DialogueManager.dialogue_ended
	
	print('done?')
	gamecycle()

func rate_globe(person:Person,globe:AssemblyGlobe) -> int:
	var stats: PeopleStat = person.stats
	var ranking := 10
	if globe.owned_parts[globe.Parts.Base] in stats.base_ranks:
		ranking -= stats.base_ranks.find(globe.owned_parts[globe.Parts.Base])
	else:
		ranking -= 3
		
	if globe.owned_parts[globe.Parts.Inside] in stats.inside_ranks:
		ranking -= stats.inside_ranks.find(globe.owned_parts[globe.Parts.Inside])*2
	else:
		ranking -= 7
	
	return ranking


func _dialogue_started(__):
	is_dialogue_active = true
	sfx.stream = hello
	sfx.play()


func _dialogue_ended(__):
	is_dialogue_active = false


func _on_talk_button_pressed() -> void:
	if active_state == GameStates.selling:
		if not is_dialogue_active:
			DialogueManager.show_dialogue_balloon_scene(EXAMPLE_BALLOON,load(active_person.dialogue),"start")


func globe_finished_unfinished(globe,finished:bool):
	if finished:
		finished_globes.append(globe)
	else:
		finished_globes.erase(globe)
		
	if finished_globes.size() >= todays_people.size():
		_enough_globes_done.emit()


func _on_parts_location_child_entered_tree(node: Node) -> void:
	all_objects.append(node)
	if node is GlobePart:
		all_parts.append(node)
	elif node is AssemblyGlobe:
		all_globes.append(node)
		node.finished_unfinished.connect(globe_finished_unfinished)


func _on_parts_location_child_exiting_tree(node: Node) -> void:
	all_objects.erase(node)
	if node is GlobePart:
		all_parts.erase(node)
	elif node is AssemblyGlobe:
		all_globes.erase(node)
		finished_globes.erase(node)


var selling_globe

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("just_released_mouse"):
		if selling_globe:
			_sold_globe.emit(selling_globe)


func _on_selling_area_2d_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is AssemblyGlobe:
		if body.dropable:
			if body.finished:
				body.modulate.g = 0
				selling_globe = body


func _on_selling_area_2d_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body is AssemblyGlobe:
		if body.dropable:
			if selling_globe == body:
				selling_globe.modulate.g = 1
				selling_globe = null


func pick_random_unique_elements(source_array: Array, amount: int) -> Array:
	# Ensure we don't try to pick more elements than are available
	if amount > source_array.size():
		amount = source_array.size()

	var copy = source_array.duplicate()
	copy.shuffle()

	return copy.slice(0, amount)
