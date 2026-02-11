extends Node2D

const ROTATION_SPEED = 2.0
@export var player_to_follow: Node2D

func _physics_process(delta: float) -> void:
	rotation += ROTATION_SPEED * delta

	if player_to_follow:
		global_position = player_to_follow.global_position
