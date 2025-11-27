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
		
		# Award more points for silver chest
		var silver_points = GameManager.chest_points + 15  # 40 points
		GameManager.add_points(silver_points)
		
		print("Silver Chest opened! Full health restored! +", silver_points, " points")
