extends Area2D

var opened = false

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and not opened:
		opened = true
		
		# Play open animation
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("open")
		
		# Give player full health
		if body.has_method("heal_to_full"):
			body.heal_to_full()
		
		# Award even more points for gold chest
		var gold_points = GameManager.chest_points + 35  # 60 points
		GameManager.add_points(gold_points)
		
		print("Gold Chest opened! Full health restored! +", gold_points, " points")
