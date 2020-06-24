extends Control

var viewport_size : Vector2

signal pause()

func _ready():
	viewport_size = get_viewport_rect().size
	$TimeLabel.rect_position.x = (viewport_size.x - $TimeLabel.rect_size.x) / 2
	$UpperRight.rect_position.x = viewport_size.x
	$BottomRight.rect_position.x = viewport_size.x

func set_caught_label(value : int) -> void:
	$PeopleCaught/Label.text = str(value)


func _on_Spawner_people_caught(value):
	set_caught_label(value)

func set_timer_label(value : int) -> void:
	$TimeLabel.text = str(value)


func _on_Spawner_update_timer(value):
	set_timer_label(value)


func _on_Pausebutton_pressed():
	emit_signal("pause")
