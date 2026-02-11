class_name Coin
extends CharacterBody2D


var speed =  700.0
const ROTATION_SPEED = 0.05
var spin_speed
var direction
var player: CharacterBody2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	spin_speed = randf_range(0,4)
	player = get_node("/root/Main/Player")
	#direction = Vector2(randf_range(-1.0,1.0),randf_range(-1.0, 1.0))
	
	

func _physics_process(delta: float) -> void:
	rotation += spin_speed * delta
	if player:
		direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
	else:
		direction = Vector2(randf_range(0,1), randf_range(0,1))
		velocity = direction * 100
		collision.disabled = true
	move_and_slide()
