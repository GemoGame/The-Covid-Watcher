extends Area2D

class_name People

var SPEED : int = 75

var direction : Vector2
var destruction_pos : Vector2
var timer_values : Array = [
	0.5, 1, 1.5,
	  2, 3, 5    ]

var state = move
var has_mask : bool = false
var physical_distance = true
var anim : Dictionary
var viewport_size : Vector2

signal caught()

enum {
	move,
	idle,
	leaving
}

func set_mask(value : bool) -> void:
	has_mask = value

func _ready():
	randomize()

func init_state() -> void:
	viewport_size = get_viewport_rect().size
	check_mask()
	$StateTimer.start()
	$Sprite.play(anim.move)
	init_position()

func _process(delta):
	match state:
		move:
			_move(delta)
		idle:
			pass
		leaving:
			_move(delta)

func _move(delta):
	position += direction * SPEED * delta

func get_random_direction() -> Vector2:
	var directions : Array = [Vector2.LEFT, Vector2.RIGHT]
	directions.shuffle()
	return directions.front()


func init_position() -> void:
	direction = get_random_direction()
	match direction:
		Vector2.LEFT:
			$Sprite.flip_h = true
			position = Vector2(viewport_size.x + 100, position.y)
			destruction_pos = Vector2(-100, position.y)
		Vector2.RIGHT:
			$Sprite.flip_h = false
			position = Vector2(-100, position.y)
			destruction_pos = Vector2(500, position.y)

func new_direction() -> void:
	direction = get_random_direction()
	match direction:
		Vector2.LEFT:
			$Sprite.flip_h = true
			destruction_pos = Vector2(-100, position.y)
		Vector2.RIGHT:
			$Sprite.flip_h = false
			destruction_pos = Vector2(500, position.y)

func destroy_on_pos() -> void:
	match direction:
		Vector2.LEFT:
			if position.x < destruction_pos.x:
				queue_free()
		Vector2.RIGHT:
			if position.x > destruction_pos.x:
				queue_free()

func set_random_time(values : Array) -> void:
	values.shuffle()
	$StateTimer.set_wait_time(values.front())
	

func _on_StateTimer_timeout():
	if state == leaving:
		return
	switch_state(state)
	set_random_time(timer_values)
	$StateTimer.start()

func switch_state(current_state) -> void:
	match current_state:
		move:
			state = idle
			$Sprite.play(anim.idle)
		idle:
			new_direction()
			state = move
			$Sprite.play(anim.move)

func check_mask() -> void:
	if has_mask:
		anim = {
			"move" : "move",
			"idle" : "idle"
		}
	else:
		anim = {
			"move" : "no_mask_move",
			"idle" : "no_mask_idle"
		}


func _on_People_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if not has_mask and state != leaving:
				$Sounds.play_sfx()
				no_mask_caught()
			elif not physical_distance:
				force_move()

func no_mask_caught() -> void:
	emit_signal("caught")
	state = leaving
	$Chat.show()
	$Sprite.play(anim.move)
	if direction == Vector2.RIGHT:
		$Sprite.flip_h = true
		direction = Vector2.LEFT
	else:
		$Sprite.flip_h = false
		direction = Vector2.RIGHT


func force_move() -> void:
	$Sprite.play(anim.move)
	state = move
	$StateTimer.stop()
	$StateTimer.start()

func _on_People_area_entered(area):
	if state == idle and area.z_index == z_index:
		physical_distance = false


func _on_People_area_exited(area):
	physical_distance = true


func _on_VisibilityNotifier2D_screen_exited():
	state = leaving
	$StateTimer.stop()
