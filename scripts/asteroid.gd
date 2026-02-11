class_name Asteroid

extends CharacterBody2D # veya Node2D
@export var speed: float = 20000
var player: Node2D = null
var sprite: Sprite2D
var score_label
#sounds 
@onready var get_damage_sound: AudioStreamPlayer2D = $GetDamageSound
var damage_number_scene = preload("res://Scenes/damage_number.tscn")

var direction = null

var spin_speed
var health = 100.0
var damage_rate = 33.0
var score_point = 1

# asteroid renkleri
var color_full_health = Color.WHITE
var color_low_health = Color.RED

func _ready():
	score_label = get_parent().get_node("CanvasLayer/Score")
	player = get_node("/root/Main/Player")
	sprite = $Sprite2D
	
	
	var random_angle = randf_range(0, TAU)
	
	if not direction:
		direction = Vector2.RIGHT.rotated(random_angle)
	
	spin_speed = randf_range(0,4)

func _physics_process(delta):
	
	if not player:
		return
	
	rotation += spin_speed * delta
	velocity = direction * speed * delta
	move_and_slide()

# 10 saniyede bir olusan asteroidler yok olacak
func _on_timer_timeout() -> void:
	queue_free()

func update_color():
	var health_percent = health / 100
	
	var damage_percent = 1.0 - health_percent
	sprite.modulate = color_full_health.lerp(color_low_health, damage_percent)

func update_direction(player_direction):
	direction = global_position.direction_to(player_direction)

func get_damage(damage_rate):
	health -= damage_rate
	get_damage_sound.play()
	update_color()
	
	# --- HASAR YAZISINI OLUŞTUR ---
	var dmg_text = damage_number_scene.instantiate()
	
	# Yazıyı meteora DEĞİL, ana sahneye (uzaya) ekliyoruz.
	# Neden? Çünkü meteor patlarsa (queue_free olursa) içindeki yazı da ölür, yazıyı göremeyiz.
	get_tree().current_scene.add_child(dmg_text)
	
	# Fonksiyonu çalıştır
	dmg_text.display_damage(damage_rate, global_position)
	# -----------------------------
	
	#particle_effect()
	if health <= 0:
		explode()

func particle_effect(bullet_pos):
	%AsteroidHitParticle.global_position = bullet_pos
	%AsteroidHitParticle.emitting = true

func explode():
	# patlama sahnesini aldik
	var explosion_scene = preload("res://Scenes/animations/explosion_animation.tscn")
	# bir ornegini olusturduk
	var new_explosion = explosion_scene.instantiate()
	
	# pozisyonunu ve scaleini asteroid ile ayni yaptik
	new_explosion.global_position = global_position
	new_explosion.scale = scale * 6
	
	get_parent().add_child(new_explosion)
	new_explosion.play("explode")
	queue_free()
	generate_coin()
	score_label.text = str(int(score_label.text) + score_point)

func generate_coin():
	var coin_anim = preload("res://Scenes/animations/gold_coin.tscn")
	var new_coin = coin_anim.instantiate()
	new_coin.global_position = global_position
	get_parent().add_child(new_coin)




func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("bullet_anim"):
		particle_effect(area.global_position)
