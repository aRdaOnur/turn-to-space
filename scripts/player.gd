extends CharacterBody2D

class_name player
var space_ship = GlobalState.ships[GlobalState.selected_ship_id]
@export var speed = 0
@export var ROTATION_SPEED = 0.05
@export var acceleration:float = 0.05
@export var friction: float = 0.02
# Movement
@onready var joystick = $"../CanvasLayer/Virtual Joystick2"
@onready var progress_bar: ProgressBar = %HealthBar
# Sounds
@onready var sound_pickup = $PickUp
@onready var thank_you: AudioStreamPlayer2D = $ThankYou
#@onready var get_damage_sound: AudioStreamPlayer2D = $GetDamageSound

# Collected Items
@onready var coin_counter: Label = $"../CanvasLayer/CoinCounter"
@onready var astroneer_counter: Label = $"../CanvasLayer/AstroneerCounter"
@onready var iron_counter: Label = $"../CanvasLayer/IronCounter"

# setting bullet fire 
@onready var fire_rate_timer: Timer = $FireRateTimer

# camera
@onready var camera2d: Camera2D = %Camera2D

# Toplanan astronot coin demir
var asteroid_scene
var bullet_scene
var health = space_ship["health"]

# kaydedilecek olan dgiskenler

var coins: int = 0
var astroneers: int = 0
var irons: int = 0

# signals
signal player_died


func _ready():
	asteroid_scene = preload("res://Scenes/asteroid.tscn")
	bullet_scene = preload("res://Scenes/bullet.tscn")
	progress_bar.visible = false
	fire_rate_timer.wait_time = space_ship["fire_wait_time"]
	speed = space_ship["speed"]
	set_camera()

func _physics_process(delta):
	
	#if Input.is_action_pressed("move_left"):
		#rotation -= ROTATION_SPEED
	#elif Input.is_action_pressed("move_right"):
		#rotation += ROTATION_SPEED
	#velocity = Vector2.UP.rotated(rotation) * speed
	#move_and_slide()

 	#Joystick

	#var direction = joystick.output
	#if direction.length() > 0.1:
		#velocity = direction * speed
		#rotation = direction.angle() + deg_to_rad(90)
	#else:
		#velocity = Vector2.ZERO
	#move_and_slide()
	
	var direction = joystick.output
	
	# Eğer joystick oynatılıyorsa (Hareket var)
	if direction.length() > 0.1:
		# 1. Yön Dönme (Senin kodun, aynen kalıyor)
		rotation = direction.angle() + deg_to_rad(90)
		
		# 2. Hızlanma (Ataletli)
		# Hedef hızımız: Gideceğimiz yön * Globalden gelen Maksimum Hız (speed)
		var target_velocity = direction * speed
		
		# Mevcut hızı, hedef hıza yavaş yavaş çekiyoruz (Acceleration oranıyla)
		velocity = velocity.lerp(target_velocity, acceleration)
		
	else:
		# 3. Yavaşlama / Sürtünme (Joystick bırakılınca)
		# Hızı yavaş yavaş SIFIR'a çekiyoruz (Friction oranıyla)
		velocity = velocity.lerp(Vector2.ZERO, friction)

	%HealthBarContainer.global_rotation = 0.0
	move_and_slide()
	

func fire():
	var new_bullet = bullet_scene.instantiate()
	
	# mermiyi ana sahneye eklemek icin get_parent() ile ana sahneye erisilir
	get_parent().add_child(new_bullet)
	
	# merminin konumunu ve rotasyonunu player ile ayni yaptik
	new_bullet.global_position = global_position
	new_bullet.rotation = rotation
	
func double_fire():
	var new_bullet1 = bullet_scene.instantiate()
	
	get_parent().add_child(new_bullet1)
	
	new_bullet1.global_position = global_position + Vector2(20, 20)
	new_bullet1.rotation = rotation
	
	# 2. mermi
	var new_bullet2 = bullet_scene.instantiate()
	get_parent().add_child(new_bullet2)
	
	new_bullet2.global_position = global_position + Vector2(-20, -20)
	new_bullet2.rotation = rotation

func special_ability():
	if not space_ship["special_ability"]:
		return
	
	if space_ship["special_ability"] == "shock_wave":
		pass

func _on_fire_rate_timer_timeout() -> void:
	if space_ship["shoot_count"] == 1:
		fire()
	elif space_ship["shoot_count"] == 2:
		double_fire()

func get_damage(damage_rate):
	progress_bar.show()
	#get_damage_sound.play()
	health -= damage_rate
	progress_bar.value = health
	if health <= 0:
		player_died.emit()
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
# oyuncunun area2d icindeki coliderina giris yapilirsa 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Coin:
		sound_pickup.play()
		coins += 1
		coin_counter.text = str(coins)
		body.queue_free()
		
	elif body is Astroneer:
		sound_pickup.play()
		thank_you.play()
		astroneers += 1
		astroneer_counter.text = str(astroneers)
		body.queue_free()
		
	elif body is IronOre:
		sound_pickup.play()
		irons += 1
		iron_counter.text = str(irons)
		body.queue_free()
		
	elif body is Asteroid:
		get_damage(body.damage_rate)
		body.explode()
	elif body is IronAsteroid:
		get_damage(body.damage_rate)
		body.explode()
		
	elif body is Duck:
		body.queue_free()
	

# --- Camera settings according to difficulty
func set_camera():
	var difficulty = GlobalState.game_settings["difficulty"]
	
	if difficulty == "easy":
		camera2d.zoom.x = 0.85
		camera2d.zoom.y = 0.85
	elif difficulty == "medium":
		camera2d.zoom.x = 0.6
		camera2d.zoom.y = 0.6
	elif difficulty == "hard":
		camera2d.zoom.x = 0.4
		camera2d.zoom.y = 0.4
	
