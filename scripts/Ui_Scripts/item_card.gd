extends PanelContainer

@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var label: Label = $VBoxContainer/Label

func update_item_card(item_texture: Texture, item_name: String):
	texture_rect.texture = item_texture
	label.text = item_name
