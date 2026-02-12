extends Control

# GAME NODES
@onready var main_ship_texture: TextureRect = $CanvasLayer/MarginContainer/VBoxContainer/ShipTexture
@onready var score_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/ScoreLabel

# Assets
@onready var coin_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/Assets/Coin/CoinLabel
@onready var astroneer_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/Assets/Astroneer/AstroneerLabel
@onready var iron_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/Assets/Iron/IronLabel


# Market Place Items
@onready var ship: PanelContainer = $CanvasLayer/MarginContainer/VBoxContainer/MarketPlace/Ship
@onready var second_weapon: PanelContainer = $CanvasLayer/MarginContainer/VBoxContainer/MarketPlace/SecondWeapon
@onready var third_weapon: PanelContainer = $CanvasLayer/MarginContainer/VBoxContainer/MarketPlace/ThirdWeapon
@onready var bullet: PanelContainer = $CanvasLayer/MarginContainer/VBoxContainer/MarketPlace/Bullet


var current_ship = GlobalState.get_current_ship();

func _ready() -> void:
	main_ship_texture.texture = current_ship["texture"]
	load_assets()
	load_shop_cards()

func load_shop_cards():
	ship.update_item_card(current_ship["texture"], current_ship["name"])

func load_assets():
	coin_label.text = GlobalState.stringify_int(GlobalState.total_coins)
	iron_label.text = GlobalState.stringify_int(GlobalState.total_irons)
	astroneer_label.text = GlobalState.stringify_int(GlobalState.total_astroneers)
