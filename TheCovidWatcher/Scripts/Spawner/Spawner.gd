extends Node2D


onready var y_pos = [
	Vector2(self.position.y, 1),
	Vector2(position.y + 10, 2),
	Vector2(position.y + 20, 3),
	Vector2(position.y + 30, 4)
]
var no_mask_chance : int = 40
var people_caught : int = 0
var rng
export (PackedScene) var people
var game_time : int = 120

signal people_caught(value)
signal update_timer(value)
signal game_over(final_score)


func _ready():
	rng = RandomNumberGenerator.new()
	randomize()
	rng.randomize()
	spawn_people()
	$SpawnTimer.start()
	$Timer.start()
	emit_signal("update_timer", game_time)

func _on_SpawnTimer_timeout():
	spawn_people()


func spawn_people() -> void:
	var new_people = people.instance()
	new_people.set_mask(give_mask())
	new_people.connect("caught", self, "people_caught")
	add_child(new_people)
	new_people.init_state()
	var y_position = get_random_y_position(y_pos)
	new_people.global_position.y = y_position.x
	new_people.z_index = y_position.y


func give_mask() -> bool:
	var roll = rng.randi_range(0, 100)
	print(roll)
	if roll > no_mask_chance:
		return true
	return false


func get_random_y_position(values : Array) -> Vector2:
	values.shuffle()
	return values.front()


func people_caught() -> void:
	people_caught += 1
	emit_signal("people_caught", people_caught)


func _on_Timer_timeout():
	game_time -= 1
	emit_signal("update_timer", game_time)
	if game_time < 0:
		$Timer.stop()
		emit_signal("game_over", people_caught)
