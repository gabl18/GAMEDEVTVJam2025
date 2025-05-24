extends Panel

@onready var email_list: ItemList = %EmailList

@onready var from_label: Label = %From_Label
@onready var to_label: Label = %To_Label
@onready var subject_label: Label = %Subject_Label
@onready var email_text_block: RichTextLabel = %Email_Text_Block

@export var icon_email_normal: Texture2D
@export var icon_email_open: Texture2D
@export var icon_email_new: Texture2D

@export var starter_email: EmailRes

var previous_selected_id: int

func _ready() -> void:
	send_email(starter_email)
	_on_item_list_item_selected(0)

func send_email(email:EmailRes):
	var idx = email_list.add_item(email.subject,icon_email_new)
	email_list.set_item_metadata(idx,email)

func _on_item_list_item_selected(index: int) -> void:
	if previous_selected_id != null:
		email_list.set_item_icon(previous_selected_id,icon_email_normal)
		
	email_list.set_item_icon(index,icon_email_open)
	var email: EmailRes = email_list.get_item_metadata(index)
	from_label.text = email.from
	to_label.text = email.to
	subject_label.text = email.subject
	email_text_block.text = email.text
	previous_selected_id = index
	

	
	
