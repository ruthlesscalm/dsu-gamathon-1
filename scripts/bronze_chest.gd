extends Area2D

var opened = false

func _on_body_entered(body):
	if body.name == "Player" and not opened:
		opened = true
		$Sprite2D.frame = 1  # opened chest frame
		print("You got loot")
