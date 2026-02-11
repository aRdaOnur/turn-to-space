extends Area2D

@export var damage_rate = 90
@export var max_radius = 500.0 # Maksimum büyüklük
@export var pulse_duration = 3.0 # Büyüme hızı (Halkanın genişleme süresi)

@onready var particles = $CPUParticles2D
@onready var collision_shape = $CollisionShape2D
@onready var timer = $Timer

func _ready():
	# 1. Çarpışma şeklini kopyala (Diğer nesneler etkilenmesin diye)
	# Bunu sadece oyun başında BİR KERE yapıyoruz.
	var new_shape = collision_shape.shape.duplicate()
	collision_shape.shape = new_shape
	
	# Timer sinyalini bağla
	timer.timeout.connect(start_pulse)
	
	# İlk dalgayı hemen başlat (Beklemesin dersen bu satırı sil)
	start_pulse()

func start_pulse():
	# --- SIFIRLAMA ---
	# Çarpışma alanını minicik yap
	collision_shape.shape.radius = 1.0 
	
	# Görsel efekti (Particle) yeniden başlat
	particles.restart()
	particles.emitting = true
	
	# --- BÜYÜTME (ANIMASYON) ---
	var tween = create_tween()
	
	# Yarıçapı 0'dan max_radius'a kadar büyüt
	tween.tween_property(collision_shape.shape, "radius", max_radius, pulse_duration)
	
	# İsteğe bağlı: Büyüme bitince collision'ı kapatabilirsin ki
	# aradaki bekleme süresinde (Cooldown) kimseye zarar vermesin.
	# (Bunu yapmak için CollisionShape2D'nin 'disabled' özelliğini kullanabiliriz)

func _on_body_entered(body):
	if body is Asteroid:
		body.get_damage(damage_rate)
	if body is IronAsteroid:
		body.get_damage(damage_rate)
