extends Control

func _ready():
    pass

func _on_restart_pressed():
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed():
    get_tree().quit()
