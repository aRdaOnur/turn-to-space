class_name Duck
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var direction
var spin_speed

func _ready():
	direction = Vector2(randf_range(-0.7,0.7), randf_range(-0.7,0.7))
	spin_speed = randf_range(0,1)
	
func _physics_process(delta: float) -> void:
	rotation += spin_speed * delta
	velocity = direction * SPEED
	move_and_slide()


# 15 saniye doldugunda astronot olecek
func _on_timer_timeout() -> void:
	queue_free()
