extends Node2D

var enemy = ""
var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var e = load(enemy).instantiate()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	queue_free()
