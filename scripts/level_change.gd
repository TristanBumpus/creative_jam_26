extends Node2D

var width = 512
var height = 352

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var level = load("res://levels/level_1.tscn").instantiate()
		
		get_tree().current_scene.add_child(level)
		
		level.global_position = global_position + Vector2(width/2,height/2)
