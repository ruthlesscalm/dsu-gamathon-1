class_name Player extends CharacterBody2D

const SPEED: float = 100.0
var Direction: Vector2 = Vector2.ZERO
var LastDirection: Vector2 = Vector2.DOWN
var LastDirectionString: String = "down"
var attacking := false

var map_width  = 49
var map_height = 49
var tile_size  = 32

var world_width   = 1568
var world_height = 1568




@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	if attacking:
		velocity = Vector2.ZERO
	else:
		velocity = Direction * SPEED

	move_and_slide()
	
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
	
	attacking = false


	
		
