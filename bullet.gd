extends Area2D

var current_ship = GlobalState.ships[GlobalState.selected_ship_id]
var speed = current_ship["bullet_speed"]
var damage_rate = 33.0
@onready var bulletAnim = preload("res://Scenes/bullet_explosion.tscn")

func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		bullet_anim()
		body.get_damage(damage_rate)
	elif body is IronAsteroid:
		bullet_anim()
		body.get_damage(damage_rate)
	queue_free()
		

func bullet_anim():
	# mermi patladiktan sonraki animasyon
	#var new_bullet_anim = bulletAnim.instantiate()
	#new_bullet_anim.global_position = global_position
	#get_parent().add_child(new_bullet_anim)
	#new_bullet_anim.play("explode")
	pass
	

func _on_bullet_timer_timeout() -> void:
	queue_free()
