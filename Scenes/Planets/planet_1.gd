extends CharacterBody2D
class_name Planet1

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction: Vector2
@onready var planet_ui: CanvasLayer = $PlanetUI


func _ready():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is player:
		planet_ui.visible = true
		get_tree().paused = true

#func _on_area_2d_area_exited(area: Area2D) -> void:
	#if area.get_parent() is player:
		#planet_ui.visible = false
		#print("ansjkd")
