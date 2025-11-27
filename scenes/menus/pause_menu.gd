extends Control
func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed():
	pass # Replace with function body.

func _on_restart_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	pass # Replace with function body.
