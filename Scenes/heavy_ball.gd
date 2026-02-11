extends CharacterBody2D

const ROTATION_SPEED = 0.5
var damage_rate = 50.0

func _physics_process(delta: float) -> void:
	rotation = ROTATION_SPEED * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Asteroid or body is IronAsteroid:
		body.get_damage(damage_rate)
