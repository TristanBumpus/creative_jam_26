extends Node2D

"""
Variables
"""
var player_movement: Vector2
var mouse_position: Vector2

@export var health: float = 100
@export var base_attack: float = 10
@export var player_speed: float = 10


"""
Engine functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test exponential growth")
	for i in range(10):
		print(1.5 ** (1 + i))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
#	get input for movement
	player_movement = Input.get_vector("a", "d", "s", "w")
	player_movement.y *= -1
	
#	get player direction through mouse position
	mouse_position = get_viewport().get_mouse_position()
	#print(mouse_position)
	
#	apply movement to player
	translate(player_movement * player_speed)
	#print(player_movement)
	
#	apply direction to player
	look_at(mouse_position)
	pass
