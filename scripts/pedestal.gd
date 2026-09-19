extends StaticBody2D

var player_in = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		var level_up = load("res://ui/upgrade.tscn").instantiate()
		get_tree().current_scene.add_child(level_up)
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		player_in = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	player_in = false
