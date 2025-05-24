extends Resource
class_name EmailRes

@export_placeholder('sender@email.com') var from: String
@export_placeholder('reseiver@email.com') var to: String = "office@tinyglob.es"
@export var subject: String
@export_multiline() var text: String
