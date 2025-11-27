class_name Enemy extends CharacterBody2D

@export var speed := 40
@export var health := 30
@export var damage := 10
@export var detection_radius := 160.0
@export var attack_range := 16.0
@export var patrol_distance := 96.0
@export var attack_cooldown := 1.0
@export var knockback_strength := 180.0
@export var keep_distance := 64.0
@export var retreat_distance := 64.0

@export var lunge_speed := 120.0
@export var lunge_distance := 32.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var start_pos: Vector2
var patrol_dir := 1
var attack_timer := 0.0
var stunned := false
var _stun_timer: Timer
var is_lunging := false
var lunge_target := Vector2.ZERO
var retreating := false
var retreat_target := Vector2.ZERO

func _ready():
	start_pos = global_position
	add_to_group("enemy")
	_stun_timer = Timer.new()
	_stun_timer.one_shot = true
	add_child(_stun_timer)

func _physics_process(delta):
	attack_timer = max(0.0, attack_timer - delta)
	if stunned:
		move_and_slide()
		return
	if is_lunging:
		_lunge(delta)
		return
	if retreating:
		var to_target = retreat_target - global_position
		if to_target.length() < 4:
			retreating = false
			attack_timer = attack_cooldown
			return
		var back_dir = to_target.normalized()
		velocity = back_dir * speed
		animation_player.play("walk_side")
		sprite.scale.x = -1 if back_dir.x < 0 else 1
		move_and_slide()
		return
	var players = get_tree().get_nodes_in_group("player")
	var player = null
	if players.size() > 0:
		player = players[0]

	if player:
		var to_player = player.global_position - global_position
		var dist = to_player.length()
		if dist <= detection_radius:
			_chase_player(player, dist, delta)
			return

	_patrol(delta)

func _chase_player(player, dist, _delta):
	var to_player = player.global_position - global_position
	var dir = to_player.normalized()

	if attack_timer > 0.0:
		velocity = Vector2.ZERO
		animation_player.play("idle_down")
		return

	if dist > keep_distance:
		velocity = dir * speed
		if abs(dir.x) > abs(dir.y):
			animation_player.play("walk_side")
			sprite.scale.x = -1 if dir.x < 0 else 1
		else:
			animation_player.play("walk_up" if dir.y < 0 else "walk_down")
		move_and_slide()
		return

	if dist <= keep_distance and attack_timer <= 0.0:
		is_lunging = true
		lunge_target = global_position + dir * lunge_distance
		attack_timer = attack_cooldown

func _lunge(delta):
	var to_target = lunge_target - global_position
	if to_target.length() < 4:
		is_lunging = false
		retreating = true
		retreat_target = global_position - (lunge_target - global_position).normalized() * lunge_distance
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			var player = players[0]
			if player and player.has_method("take_damage"):
				var dist = (player.global_position - global_position).length()
				if dist <= attack_range:
					player.take_damage(damage)
		return

	var lunge_dir = to_target.normalized()
	velocity = lunge_dir * lunge_speed
	animation_player.play("walk_side")
	sprite.scale.x = -1 if lunge_dir.x < 0 else 1
	move_and_slide()

func _patrol(_delta):
	var target = start_pos + Vector2(patrol_distance * patrol_dir, 0)
	var dir = target - global_position
	if dir.length() < 4:
		patrol_dir *= -1
		target = start_pos + Vector2(patrol_distance * patrol_dir, 0)
		dir = target - global_position

	if dir.length() > 1:
		var move_dir = dir.normalized()
		velocity = move_dir * (speed * 0.6)
		if abs(move_dir.x) > abs(move_dir.y):
			animation_player.play("walk_side")
			sprite.scale.x = -1 if move_dir.x < 0 else 1
		else:
			animation_player.play("walk_down")
	else:
		velocity = Vector2.ZERO
		animation_player.play("idle_down")

	move_and_slide()

func take_damage(amount):
	health -= amount
	if health <= 0:
		_die()

func apply_knockback(kvec: Vector2, stun: float = 0.12) -> void:
	velocity = kvec
	stunned = true
	_stun_timer.start(stun)
	await _stun_timer.timeout
	stunned = false

func _die():
	animation_player.play("death")
	await animation_player.animation_finished
	queue_free()
