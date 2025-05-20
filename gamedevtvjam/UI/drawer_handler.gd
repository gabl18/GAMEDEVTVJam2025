extends Node

var layer_1: Array[GlobePart]
var layer_2: Array[GlobePart]
var layer_3: Array[GlobePart]
var layer_4: Array[GlobePart]
var layers = [layer_1,layer_2,layer_3,layer_4]

var active_layer = 0
var opened = false


func _on_drawer_area_2d_area_entered(area: Area2D) -> void:
	if opened:
		layers[active_layer].append(area.get_parent())
		
		area.get_parent().z_index = 0


func _on_drawer_area_2d_area_exited(area: Area2D) -> void:
	if opened:
		layers[active_layer].erase(area.get_parent())
		
		area.get_parent().z_index = 1


func _on_texture_rect_changed_drawer_layer(value: int) -> void:
	if wrapi(active_layer + value, 0, layers.size()) != active_layer:
		var scuffed = active_layer
		active_layer = wrapi(active_layer + value, 0, layers.size())
		show_layer(active_layer)
		#await get_tree().create_timer(0.25).timeout
		hide_layer(scuffed)


func _on_texture_rect_drawer_opened_closed(open: bool) -> void:
	opened = open
	if opened:
		show_layer(active_layer)
	else:
		await get_tree().create_timer(0.25).timeout
		hide_layer(active_layer)


func show_layer(layerindex: int):
	for body in layers[layerindex]:
		body.visible = true


func hide_layer(layerindex: int):
	for body in layers[layerindex]:
		body.visible = false
