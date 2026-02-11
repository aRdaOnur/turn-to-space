extends Panel

var current_ship_id = GlobalState.selected_ship_id
var current_ship = GlobalState.ships[current_ship_id]
var ship_count = GlobalState.ships.size() 

# uzay gemisinin fiyati fotosu ismi filan burada
@onready var space_ship_2: Button = $SpaceShip2
@onready var name_of_ship: Label = $CurrentShip/Name
@onready var spaceship: Sprite2D = $CurrentShip/Spaceship

# sag sol butonlari
@onready var right_button: Button = $RightButton
@onready var left_button: Button = $LeftButton

# fiyatlar 
@onready var amount_of_astroneer: Label = $Prices/Astrooner/AmountOfAstroneer
@onready var amount_of_coin: Label = $Prices/Coin/AmountOfCoin
@onready var amount_of_iron: Label = $Prices/Iron/AmountOfIron

#selected butonu
@onready var select: Button = $CurrentShip/Select


signal bought_ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spaceship.scale = Vector2(7,7)
	set_ship()

func set_ship():
	name_of_ship.text= current_ship["name"]
	spaceship.texture = current_ship["texture"]
	
	amount_of_astroneer.text = str(current_ship["astroneer"])
	amount_of_coin.text = str(current_ship["coin"])
	amount_of_iron.text = str(current_ship["iron"])
	select_button()
		

func select_button():
	if GlobalState.selected_ship_id == current_ship_id:
		select.text = "Selected"
		
		var new_style = StyleBoxFlat.new()
		new_style.bg_color = Color("111")
		select.add_theme_color_override("font_color", Color("FFF"))
		select.add_theme_stylebox_override("normal", new_style)
	
	elif current_ship_id not in GlobalState.owned_ship_ids:
		select.text = "Buy"
		var new_style = StyleBoxFlat.new()
		
		new_style.bg_color = Color("888")
		select.add_theme_color_override("font_color", Color("111"))
		select.add_theme_stylebox_override("normal", new_style)
		
	else:
		select.text = "Select"
		var new_style = StyleBoxFlat.new()
		
		new_style.bg_color = Color("888")
		select.add_theme_color_override("font_color", Color("111"))
		select.add_theme_stylebox_override("normal", new_style)

func _on_right_button_pressed() -> void:
	if  ship_count > current_ship_id:
		current_ship_id += 1
		current_ship = GlobalState.ships[current_ship_id]
	else:
		current_ship_id = 1
	current_ship = GlobalState.ships[current_ship_id]
	set_ship()

func _on_left_button_pressed() -> void:
	if  1 < current_ship_id:
		current_ship_id -= 1
		current_ship = GlobalState.ships[current_ship_id]
	else:
		current_ship_id = ship_count
	current_ship = GlobalState.ships[current_ship_id]
	set_ship()
	
func buy_ship():
	if GlobalState.total_coins < current_ship["coin"]:
		print("You don't have enough coin")
		return
	
	elif GlobalState.total_irons < current_ship["iron"]:
		print("You don't have enough iron")
		return
	
	elif GlobalState.total_astroneers < current_ship["astroneer"]:
		print("You don't have enough astroneer")
		return
	
	# you can buy
	else:
		GlobalState.total_coins -= current_ship["coin"]
		GlobalState.total_irons -= current_ship["iron"]
		GlobalState.total_astroneers -= current_ship["astroneer"]
		GlobalState.owned_ship_ids.append(current_ship["id"])
		GlobalState.save_data()
		select_button()
		bought_ship.emit()
	


func _on_select_pressed() -> void:
	if current_ship_id not in GlobalState.owned_ship_ids:
		buy_ship()
		return
		
	GlobalState.selected_ship_id = current_ship_id
	GlobalState.save_data()
	select_button()
	set_ship()
	
	if owner.has_method("update_visuals"):

		owner.update_visuals()
