extends Control

func _ready():
	visible = false  # hide pause menu at start

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func resume():
	get_tree().paused = false
	visible = false   # hide pause screen

func pause():
	get_tree().paused = true
	visible = true    # show pause screen

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
