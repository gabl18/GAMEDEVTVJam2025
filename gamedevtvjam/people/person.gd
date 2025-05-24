extends Resource
class_name Person

@export var name: String
@export var texture: Texture2D
@export_file("*.dialogue") var dialogue

@export_range(0,10,1.,":days") var earliest_day = 0
@export_range(0,10,1.,":days") var latest_day = 10

@export var only_after: Person

@export var emails: Array[EmailRes]

@export var stats: PeopleStat
