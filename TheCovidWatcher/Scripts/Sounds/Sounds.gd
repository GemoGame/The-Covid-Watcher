extends Node2D


export (AudioStream) var music
export (AudioStream) var sfx


func _ready():
	if music != null:
		play_music()


func play_music() -> void:
	$Music.stream = music
	$Music.play()

func play_sfx() -> void:
	$Sfx.stream = sfx
	$Sfx.play()	
