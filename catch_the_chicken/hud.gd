extends CanvasLayer

signal start_game

var doneGame = false


func show_final_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	doneGame = true


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	if !doneGame:
		$MessageTimer.start()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	$CreditsButton.hide()
	$CreditsLabel.hide()
	start_game.emit()
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		show_movement_buttons()
	else:
		show_message("Arrow keys or WASD to move")


func _on_MessageTimer_timeout():
	if !doneGame:
		$MessageLabel.hide()


func show_movement_buttons():
	$Up.show()
	$Down.show()
	$Left.show()
	$Right.show()


func _on_up_button_down():
	var ev = InputEventAction.new()
	ev.action = "move_up"
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_down_button_down():
	var ev = InputEventAction.new()
	ev.action = "move_down"
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_left_button_down():
	var ev = InputEventAction.new()
	ev.action = "move_left"
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_right_button_down():
	var ev = InputEventAction.new()
	ev.action = "move_right"
	ev.pressed = true
	Input.parse_input_event(ev)


func _on_up_button_up():
	var ev = InputEventAction.new()
	ev.action = "move_up"
	ev.pressed = false
	Input.parse_input_event(ev)


func _on_down_button_up():
	var ev = InputEventAction.new()
	ev.action = "move_down"
	ev.pressed = false
	Input.parse_input_event(ev)


func _on_left_button_up():
	var ev = InputEventAction.new()
	ev.action = "move_left"
	ev.pressed = false
	Input.parse_input_event(ev)


func _on_right_button_up():
	var ev = InputEventAction.new()
	ev.action = "move_right"
	ev.pressed = false
	Input.parse_input_event(ev)


func _on_credits_button_pressed():
	$CreditsButton.hide()
	$CreditsLabel.show()
