extends CanvasLayer

@onready var planet_ui: CanvasLayer = $"."

func _on_close_button_pressed() -> void:
	planet_ui.visible = false
	get_tree().paused = false
