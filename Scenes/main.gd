extends Node2D

var asteroid_scene = preload("res://Scenes/asteroid.tscn")
const astroneer_scene = preload("res://Scenes/astroneer.tscn")
const iron_asteroid = preload("res://Scenes/iron_asteroid.tscn")
const duck = preload("res://Scenes/duck.tscn")

@export var asteroid_spawn_radius: float = 1400.0
var astroneer_spawn_radius = 900
var duck_spawn_radius = 1000
# oyundaki degiskenler
@onready var current_score: Label = $CanvasLayer/Score
@onready var asteroid_spawner_timer: Timer = %AsteroidSpawner

var player

const MIN_ASTEROID_SCALE = 0.5
const MAX_ASTEROID_SCALE = 0.7

func _ready():
	# secilen uzay gemisini oyun sahnesine koy
	player = GlobalState.load_player_ship().instantiate()
	player.global_position = Vector2(0,0)
	add_child(player)
	
	# asteroid spawn et
	spawn_asteroid()
	spawn_iron_asteroid()
	spawn_duck()
	
	# player öldüğünde game_over
	player.player_died.connect(game_over)
	GlobalState.load_data()

func spawn_astroneer():
	var new_astroneer = astroneer_scene.instantiate()
	var random_angle = randf_range(0, TAU) # 0 ile 360 derece arasinda rastegele aci
	

	var offset = Vector2.RIGHT.rotated(random_angle) * astroneer_spawn_radius
	new_astroneer.global_position = player.global_position + offset
	add_child(new_astroneer)

func spawn_duck():
	var new_duck = duck.instantiate()
	var random_angle = randf_range(0, TAU)
	
	var offset = Vector2.RIGHT.rotated(random_angle) * duck_spawn_radius
	new_duck.global_position = player.global_position + offset
	add_child(new_duck)


func spawn_iron_asteroid():
	var new_iron_asteroid = iron_asteroid.instantiate()
	var random_angle = randf_range(0, TAU) # 0 ile 360 derece arasinda rastegele aci
	
	# asteroidlerin boyutlarida rastgele olacak
	var random_scale = randf_range(0.17, 0.32)
	new_iron_asteroid.scale = Vector2(random_scale, random_scale)

	# playerdan ne kadar uzak olacagini hesapliyoruz
	# offset sapma mesafe demek
	# 1 birim saga vector ciziyor ve vectoru rotate ediyor (saat gibi dusun)
	var offset = Vector2.RIGHT.rotated(random_angle) * asteroid_spawn_radius
	# asteroid in pozisyonunu player ile ayni yapip offset i ekliyor
	new_iron_asteroid.global_position = player.global_position + offset
	# sonrada sahneye ekliyoruz asteroidi
	add_child(new_iron_asteroid)

func spawn_asteroid():
	var difficulty = GlobalState.game_settings["difficulty"]
	
	if difficulty == "easy":
		easy_level()
	elif difficulty == "medium":
		medium_level()
	elif difficulty == "hard":
		hard_level()

# ------ Asteroid spawn levels ------
func easy_level():
	asteroid_spawner_timer.wait_time = 1
	
	
	var new_asteroid = asteroid_scene.instantiate()
	var random_angle = randf_range(0, TAU)
	
	var random_scale = randf_range(MIN_ASTEROID_SCALE, MAX_ASTEROID_SCALE)
	new_asteroid.scale = Vector2(random_scale, random_scale)

	var offset = Vector2.RIGHT.rotated(random_angle) * asteroid_spawn_radius
	new_asteroid.global_position = player.global_position + offset 
	new_asteroid.update_direction(player.global_position)
	add_child(new_asteroid)

func medium_level():
	asteroid_spawner_timer.wait_time = 0.1
	
	
	var new_asteroid = asteroid_scene.instantiate()
	var random_angle = randf_range(0, TAU)
	
	var random_scale = randf_range(MIN_ASTEROID_SCALE, MAX_ASTEROID_SCALE)
	new_asteroid.scale = Vector2(random_scale, random_scale)

	var offset = Vector2.RIGHT.rotated(random_angle) * asteroid_spawn_radius
	new_asteroid.global_position = player.global_position + offset 
	add_child(new_asteroid)

func hard_level():
	asteroid_spawn_radius = 2000
	asteroid_spawner_timer.wait_time = 0.05
	
	
	var new_asteroid = asteroid_scene.instantiate()
	var random_angle = randf_range(0, TAU)
	
	var random_scale = randf_range(MIN_ASTEROID_SCALE, MAX_ASTEROID_SCALE)
	new_asteroid.scale = Vector2(random_scale, random_scale)

	var offset = Vector2.RIGHT.rotated(random_angle) * asteroid_spawn_radius
	new_asteroid.global_position = player.global_position + offset 
	add_child(new_asteroid)

# SPAWN TIMERS -->
func _on_asteroid_spawner_timeout() -> void:
	spawn_asteroid()

func _on_astroneer_spawner_timeout() -> void:
	spawn_astroneer()

func _on_iron_asteroid_spawner_timeout() -> void:
	spawn_iron_asteroid()
	
func _on_duck_spawner_timeout() -> void:
	spawn_duck()

func game_over():
	# rekoru gecti ise 
	var current_score_int = int(current_score.text) 
	
	if current_score_int > GlobalState.high_score:
		GlobalState.high_score = current_score_int
	# save other values
	GlobalState.total_coins += player.coins
	GlobalState.total_astroneers += player.astroneers
	GlobalState.total_irons += player.irons
	GlobalState.save_data()
	
