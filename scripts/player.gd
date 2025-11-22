class_name Player extends CharacterBody2D

var move_speed := 100.0
var direction := Vector2.ZERO
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	direction.x = Input.get_axis("Left", "Right")
	direction.y = Input.get_axis("Front","Back")
	if direction.x == 1:
		animation_player.play("idle_side")
	elif direction.x == -1:
		animation_player.play("idle_side")
		sprite_2d.flip_h = true

func _physics_process(_delta: float) -> void:
	if direction.length():
		direction = direction.normalized()
	velocity = direction * move_speed
	
	move_and_slide()
