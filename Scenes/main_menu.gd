extends Control

# values
@onready var high_score: Label = $HighScore
@onready var amount_of_coin: Label = $CurrentCoin/AmountOfCoin
@onready var amount_of_astroneer: Label = $CurrentAstroneer/AmountOfAstroneer
@onready var amount_of_iron: Label = $CurrentIron/AmountOfIron

# Panels
var ship_select_panel: Panel
@onready var select_gun_1: Panel = $Panels/SelectGun1
@onready var select_gun_2: Panel = $Panels/SelectGun2
@onready var select_bullet: Panel = $Panels/SelectBullet

@onready var spaceship: Sprite2D = $SpaceShip
var current_ship

@onready var ship_name: Label = $Buttons/SpaceShipButton/ShipName
@onready var space_ship_sprite_2d: Sprite2D = $Buttons/SpaceShipButton/SpaceShip2


func _ready() -> void:
	ship_select_panel = $Panels/ShipSelectPanel
	high_score.text = str(GlobalState.high_score)
	spaceship.scale = Vector2(5,5)
	space_ship_sprite_2d.scale = space_ship_sprite_2d.scale * 10
	update_values()
	
	# connect signals
	ship_select_panel.bought_ship.connect(update_values)
	update_visuals()
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_space_ship_button_pressed() -> void:
	ship_select_panel.visible = true

func _on_gun_1_button_pressed() -> void:
	select_gun_1.visible = true

func _on_gun_2_button_pressed() -> void:
	select_gun_2.visible = true

func _on_bullet_label_pressed() -> void:
	select_bullet.visible = true

func update_visuals():
	# SET SHIP
	current_ship = GlobalState.ships[GlobalState.selected_ship_id]
	spaceship.texture = current_ship["texture"]
	ship_name.text = current_ship["name"]
	space_ship_sprite_2d.texture = current_ship["texture"]
	

func update_values():
	amount_of_coin.text = str(GlobalState.total_coins)
	amount_of_astroneer.text = str(GlobalState.total_astroneers)
	amount_of_iron.text = str(GlobalState.total_irons)
	
