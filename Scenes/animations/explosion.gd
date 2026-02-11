extends AnimatedSprite2D

@onready var get_damage_sound: AudioStreamPlayer2D = $GetDamageSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	get_damage_sound.play()
	queue_free()
