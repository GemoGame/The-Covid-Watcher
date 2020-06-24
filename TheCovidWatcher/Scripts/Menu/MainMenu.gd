extends CanvasLayer


func _ready():
	$MenuLabel/MenuAnim.play("blip")


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene("res://TheCovidWatcher/Scenes/Main.tscn")
