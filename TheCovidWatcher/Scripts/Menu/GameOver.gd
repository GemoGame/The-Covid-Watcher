extends Control

var wait : bool = true

func set_final_score(value : int) -> void:
	$FinalScoreLabel.text = str(value)
	$Timer.start()

func _on_Timer_timeout():
	$TouchLabel.show()
	wait = false


func _on_GameOver_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and not wait:
			get_tree().change_scene("res://TheCovidWatcher/Scenes/Menu/MainMenu.tscn")
