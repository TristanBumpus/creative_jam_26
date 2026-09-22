extends Node2D

@onready var player := get_tree().get_first_node_in_group("player")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("p"):
		global.wave = 12
		global.generate_wave(0)
		
