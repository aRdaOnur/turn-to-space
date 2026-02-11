extends Control # veya Node2D
class_name DubleClick
# Dash durumunu bildiren sinyal (True = Koşuyor, False = Durdu)
signal dash_toggled(is_active)

var last_click_time: float = 0.0
var double_click_speed: float = 0.3

# --- 1. BUTONA BASILDIĞINDA (BUTTON DOWN) ---
func _on_button_down() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	
	# Eğer son tıklamadan bu yana geçen süre kısaysa (Çift Tık)
	if current_time - last_click_time < double_click_speed:
		print("Çift Tıklandı ve Basılı Tutuluyor: DASH BAŞLADI!")
		dash_toggled.emit(true) # Player'a "Hızlan" de
	
	# Zamanı güncelle
	last_click_time = current_time

# --- 2. BUTON BIRAKILDIĞINDA (BUTTON UP) ---
func _on_button_up() -> void:
	# Parmak çekildiği an Dash biter
	dash_toggled.emit(false) # Player'a "Yavaşla" de
