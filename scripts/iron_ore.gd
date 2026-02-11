class_name IronOre
extends CharacterBody2D


const SPEED =  200.0
const ROTATION_SPEED = 0.05
var spin_speed
var player
var direction

func _ready():
	spin_speed = randf_range(0,4)
	player = get_node("/root/Main/Player")
	direction = Vector2(randf_range(-1.0,1.0),randf_range(-1.0, 1.0))
	
	

func _physics_process(delta: float) -> void:
	rotation += spin_speed * delta
	velocity = direction * SPEED  
	move_and_slide()
