extends Node2D

var player_movement: Vector2
@export var player_speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_movement = Input.get_vector("a", "d", "s", "w")
	player_movement.y *= -1
	$".".translate(player_movement * player_speed)
	#print(player_movement)
	pass
