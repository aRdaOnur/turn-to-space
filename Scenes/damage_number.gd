extends Label

func display_damage(value: int, start_pos: Vector2):
	text = str(value)
	global_position = start_pos
	
	# Yazının tam ortasından büyümesi için pivotu merkeze alıyoruz
	pivot_offset = size / 2 
	
	var tween = create_tween()
	
	# --- TATMİN EDİCİ AYARLAR BURADA ---
	
	# 1. POP EFEKTİ: Yazı bir anda 1.5 katına çıkıp sonra normale dönecek (Lastik gibi)
	scale = Vector2(0.5, 0.5) # Küçük başla
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
	# 2. YUKARI SÜZÜLME VE ŞEFFAFLAŞMA (Aynı anda çalışsınlar diye parallel() kullanıyoruz)
	tween.set_parallel(true) 
	
	# Yukarı doğru rastgele sağa sola kayarak gitsin (Daha doğal durur)
	var random_x = randf_range(-20, 20)
	tween.tween_property(self, "position", position + Vector2(random_x, -50), 0.5).set_ease(Tween.EASE_OUT)
	
	# Rengi yavaşça şeffaflaşsın (Alpha 0 olsun)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)
	
	# 3. TEMİZLİK: Animasyon bitince silinsin
	tween.set_parallel(false) # Paralel modu kapat
	tween.tween_callback(queue_free) # İş bitince kendini yok et
