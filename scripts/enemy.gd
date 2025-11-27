class_name Enemy extends CharacterBody2D

@export var patrol_speed := 30.0
@export var chase_speed := 50.0
@export var health := 60
@export var damage := 10
@export var detection_radius := 100.0
@export var attack_range := 24.0
@export var patrol_distance := 96.0
@export var attack_cooldown := 1.5
@export var keep_distance := 8.0  # 0.5 tiles (1 tile = 16 pixels)

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var start_pos: Vector2
var patrol_dir := 1
var attack_timer := 0.0
var facing_direction := Vector2.RIGHT  # Track which direction enemy is facing

# Simple state machine
var state := "patrol"  # patrol, chase, attack, dead

func _ready():
	start_pos = global_position
	add_to_group("enemy")

func _physics_process(delta):
	attack_timer = max(0.0, attack_timer - delta)
	
	if state == "dead":
		return
	
	# Try to find player
	var players = get_tree().get_nodes_in_group("player")
	var player = null
	if players.size() > 0:
		player = players[0]
	
	if player:
		var dist = (player.global_position - global_position).length()
		
		# If in range, attack
		if dist <= attack_range and attack_timer <= 0.0:
			state = "attack"
			_attack_player(player)
			return
		
		# If can see player, chase
		if dist <= detection_radius:
			state = "chase"
			_chase_player(player)
			return
	
	# Otherwise patrol
	state = "patrol"
	_patrol()

func _chase_player(player: CharacterBody2D):
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var direction = to_player.normalized()
	
	# Store facing direction for attack checks
	facing_direction = direction
	
	# If we're at or beyond keep_distance, maintain that distance (back away slowly)
	if dist > keep_distance:
		# Chase normally towards player
		velocity = direction * chase_speed
	else:
		# Too close: back away slowly to maintain distance
		velocity = -direction * (chase_speed * 0.3)  # Back away at 30% speed
	
	# Simple animation based on direction
	if abs(direction.x) > abs(direction.y):
		animation_player.play("walk_side")
		sprite.scale.x = -1 if direction.x < 0 else 1
	else:
		if direction.y < 0:
			animation_player.play("walk_up")
		else:
			animation_player.play("walk_down")
	
	move_and_slide()

func _attack_player(player: CharacterBody2D):
	velocity = Vector2.ZERO
	animation_player.play("idle_down")
	
	# Only attack if player is in front of us (within 90 degrees of facing direction)
	var to_player = (player.global_position - global_position).normalized()
	var dot_product = to_player.dot(facing_direction)
	
	# dot_product > 0 means player is in front (within 90 degrees)
	if dot_product > 0 and player.has_method("take_damage"):
		player.take_damage(damage)
	
	attack_timer = attack_cooldown

func _patrol():
	var target = start_pos + Vector2(patrol_distance * patrol_dir, 0)
	var direction = (target - global_position).normalized()
	var dist = (target - global_position).length()
	
	# Change direction if reached waypoint
	if dist < 4:
		patrol_dir *= -1
		target = start_pos + Vector2(patrol_distance * patrol_dir, 0)
		direction = (target - global_position).normalized()
	
	velocity = direction * patrol_speed
	
	# Simple animation
	if abs(direction.x) > abs(direction.y):
		animation_player.play("walk_side")
		sprite.scale.x = -1 if direction.x < 0 else 1
	else:
		animation_player.play("walk_down")
	
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		_die()

func _die():
	state = "dead"
	animation_player.play("death")
	# Free after animation finishes
	await animation_player.animation_finished
	queue_free()
	animation_player.play("death")
	await animation_player.animation_finished
	queue_free()
