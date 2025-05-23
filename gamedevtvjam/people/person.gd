extends Resource
class_name Person

@export var name: String
@export var texture: Texture2D
@export_file("*.dialogue") var dialogue

@export var only_after: Person
