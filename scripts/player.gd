class_name Player extends CharacterBody2D

@export var max_health := 100
var health := 100


const SPEED: float = 100.0
var Direction: Vector2 = Vector2.ZERO
var LastDirection: Vector2 = Vector2.DOWN
var LastDirectionString: String = "down"
var attacking := false
var stunned := false
@export var attack_damage := 20
@export var attack_range := 36.0
@export var attack_knockback := 32.0

var map_width  = 49
var map_height = 49
var tile_size  = 32

var world_width   = 1568
var world_height = 1568




@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _stun_timer: Timer
var _flash_timer: Timer

func _ready():
	# make it easy for enemies to find the player
	add_to_group("player")
	# timers to avoid relying on get_tree().create_timer (can be null in some contexts)
	_stun_timer = Timer.new()
	_stun_timer.one_shot = true
	add_child(_stun_timer)
	_flash_timer = Timer.new()
	_flash_timer.one_shot = true
	add_child(_flash_timer)

func _process(_delta: float) -> void:
	Direction.x = sign(Input.get_axis("Left","Right"))
	Direction.y = sign(Input.get_axis("up","down"))
	
	if Input.is_action_just_pressed("attack") and not attacking:
		Attack()
		return
	
	if attacking:
		return
	
	if Direction != Vector2.ZERO:
		LastDirection = Direction
		WalkAnimation()
	else:
		DirectionString()
		IdleAnimation()


func _physics_process(_delta: float) -> void:
	if Direction.length() > 1:
		Direction = Direction.normalized()
	if attacking or stunned:
		velocity = Vector2.ZERO
	else:
		velocity = Direction * SPEED

	move_and_slide()

func apply_knockback(kvec: Vector2, stun: float = 0.18) -> void:
	# apply immediate knockback and brief stun
	velocity = kvec
	stunned = true
	_stun_timer.start(stun)
	await _stun_timer.timeout
	stunned = false

func _play_damage_feedback() -> void:
	# try to play a damage animation if present, otherwise flash sprite
	var played = false
	for anim_name in ["damage", "hurt", "hit", "stagger"]:
		if animation_player.has_animation(anim_name):
			animation_player.play(anim_name)
			played = true
			break
	if not played:
		var original = sprite.modulate
		sprite.modulate = Color(1, 0.5, 0.5)
		_flash_timer.start(0.12)
		await _flash_timer.timeout
		sprite.modulate = original
	
func WalkAnimation():
	if Direction.x == 0:
		if Direction.y < 0:
			animation_player.play("walk_up")
		else:
			animation_player.play("walk_down")
	elif  Direction.y == 0:
		animation_player.play("walk_side")
		if Direction.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
	else:
		animation_player.play("walk_side")
		if Direction.x < 0:
			sprite.scale.x = -1
		elif Direction.x > 0:
			sprite.scale.x = 1


func DirectionString():
	if LastDirection == Vector2.DOWN:
		LastDirectionString = "down"
	elif LastDirection == Vector2.UP:
		LastDirectionString = "up"
	else:
		LastDirectionString = "side"

func IdleAnimation():
	animation_player.play("idle" + "_" + LastDirectionString)
	
func Attack():
	attacking = true
	DirectionString()
	
	animation_player.play("attack_" + LastDirectionString)
	await animation_player.animation_finished
	# apply hit detection to enemies in front of player
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if not is_instance_valid(e):
			continue
		var d = (e.global_position - global_position).length()
		if d <= attack_range:
			if e.has_method("take_damage"):
				e.take_damage(attack_damage)
			if e.has_method("apply_knockback"):
				var knockback_vector = (e.global_position - global_position).normalized() * attack_knockback
				e.apply_knockback(knockback_vector)

	attacking = false
	
func take_damage(amount:int):
	health -= amount
	_play_damage_feedback()
	if health <= 0:
		die()

func die():
	queue_free()
	get_tree().change_scene_to_file("res://scenes/menus/death_menu.tscn")



	
		
