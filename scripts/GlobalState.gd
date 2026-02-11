extends Node

# --- VARSAYILAN DEĞERLER (Yeni Oyun Başlangıcı) ---
# Buradaki değerleri oyun hiç kaydedilmemişse (ilk açılışta) ne olmasını istiyorsan öyle ayarla.
var high_score: int = 0
var selected_ship_id: int = 1
var total_coins: int = 100 
var total_astroneers: int = 0
var total_irons: int = 0
var owned_ship_ids: Array[int] = [1] # Başlangıçta sadece 1. gemi açık olsun

# Gemilerin verisi (Bu kısım sabit, kaydedilmesine gerek yok)
var ships = {
	1: {
		"id": 1,
		"scene": preload("res://Scenes/SpaceshipScenes/ship_1.tscn"),
		"speed": 500,
		"bullet_speed": 1500,
		"health": 100,
		"shoot_count": 1,
		"fire_wait_time": 0.2,
		"name": "Eser-31Q",
		"texture": preload("res://Assets/SpaceShips/Ship_1.png"),
		"coin" : 0, "astroneer": 0, "iron": 0
	},
	2: {
		"id": 2,
		"scene": preload("res://Scenes/SpaceshipScenes/ship_2.tscn"),
		"speed": 600,
		"bullet_speed": 1800,
		"health": 200,
		"shoot_count": 1,
		"fire_wait_time": 0.15,
		"name": "HILL-ALL",
		"texture": preload("res://Assets/SpaceShips/Ship_2.png"),
		"coin" : 1, "astroneer": 1, "iron": 1
	},
	3: {
		"id": 3,
		"scene": preload("res://Scenes/SpaceshipScenes/ship_3.tscn"),
		"speed": 650,
		"bullet_speed": 1900,
		"health": 200,
		"shoot_count": 1,
		"fire_wait_time": 0.1,
		"name": "Mamur-T44",
		"texture": preload("res://Assets/SpaceShips/Ship_3.png"),
		"coin" : 1, "astroneer": 1, "iron": 1
	},
	4: {
		"id": 4,
		"scene": preload("res://Scenes/SpaceshipScenes/ship_4.tscn"),
		"speed": 650,
		"bullet_speed": 1900,
		"health": 200,
		"shoot_count": 1,
		"fire_wait_time": 1,
		"name": "Mamur-T44",
		"texture": preload("res://Assets/SpaceShips/Ship_4.png"),
		"coin" : 1, "astroneer": 1, "iron": 1
	}
}

var game_settings = { "difficulty": "easy" }
var game_difficulty = { "easy": {}, "medium": {}, "hard": {} }

const SAVE_PATH = "user://savegame.json"

func _ready():
	load_data()

func save_data():
	var data = {
		"high_score": high_score,
		"selected_ship_id": selected_ship_id,
		"total_coins": total_coins,
		"total_astroneers": total_astroneers,
		"total_irons": total_irons,
		"owned_ship_ids": owned_ship_ids
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		printerr("Kaydetme hatası: Dosya açılamadı! Hata kodu: ", FileAccess.get_open_error())
		return

	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close() # Godot 4'te zorunlu değil ama temizlik iyidir
	print("Oyun başarıyla kaydedildi!")

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Kayıt dosyası bulunamadı, varsayılan değerlerle devam ediliyor.")
		# İstersen burada otomatik save_data() çağırıp dosyayı oluşturabilirsin.
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		printerr("Yükleme hatası: Dosya okunamadı!")
		return

	var json_string = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(json_string)
	
	# Eğer JSON bozuksa data null döner, kontrol edelim
	if data == null:
		printerr("Kayıt dosyası bozuk! JSON ayrıştırılamadı.")
		return
	
	# Verileri Yükle
	high_score = data.get("high_score", 0)
	selected_ship_id = data.get("selected_ship_id", 1)
	total_coins = data.get("total_coins", 0)
	total_astroneers = data.get("total_astroneers", 0)
	total_irons = data.get("total_irons", 0)
	
	# --- KRİTİK DÜZELTME BURADA ---
	# Eski listeyi temizlemezsen, her load ettiğinde eskinin üstüne ekler.
	owned_ship_ids.clear() 
	
	var temp_arr = data.get("owned_ship_ids", [1])
	for id in temp_arr:
		owned_ship_ids.append(int(id))
		
	print("Veriler yüklendi. Sahip olunan gemiler: ", owned_ship_ids)

func load_player_ship():
	# Hata almamak için seçili gemi gerçekten var mı kontrol et
	if ships.has(selected_ship_id):
		return ships[selected_ship_id]["scene"]
	else:
		print("HATA: Seçili gemi ID'si (", selected_ship_id, ") sözlükte yok! Default 1 yükleniyor.")
		return ships[1]["scene"]
