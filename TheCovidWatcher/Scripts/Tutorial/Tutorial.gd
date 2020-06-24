extends Control

onready var viewport = get_viewport()

var wait : bool = true
var viewport_size : Vector2
var minimum_size = Vector2(960, 540)


func _ready():
	get_tree().paused = true
	viewport.connect("size_changed", self, "window_resize")
	window_resize()


func _on_Timer_timeout():
	wait = false
	$Touch.show()


func _on_Tutorial_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and not wait:
			get_tree().paused = false
			queue_free()


func window_resize():
	var current_size = OS.get_window_size()

	var scale_factor = minimum_size.y/current_size.y
	var new_size = Vector2(current_size.x*scale_factor, minimum_size.y)

	if new_size.y < minimum_size.y:
		scale_factor = minimum_size.y/new_size.y
		new_size = Vector2(new_size.x*scale_factor, minimum_size.y)
	if new_size.x < minimum_size.x:
		scale_factor = minimum_size.x/new_size.x
		new_size = Vector2(minimum_size.x, new_size.y*scale_factor)
	
	$TextureRect.rect_scale *= current_size / viewport.size

	viewport.set_size_override(true, new_size)
