class_name Astroneer
extends CharacterBody2D

var help_text = ["save me!!", "", "", "help!", ""]
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var astroneer_says: Label = $Label
@export var anim: AnimatedSprite2D

var direction
var spin_speed
var astroneer_num:int = 1

func _ready():
	astroneer_num = randi_range(2,12)
	
	anim.play("astroneer" + str(astroneer_num))
	
	direction = Vector2(randf_range(-0.7,0.7), randf_range(-0.7,0.7))
	spin_speed = randf_range(0,1)
	if astroneer_says:
		astroneer_says.text = help_text[randi_range(0, 4)]
	
func _physics_process(delta: float) -> void:
	rotation += spin_speed * delta
	velocity = direction * SPEED
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()
