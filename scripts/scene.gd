extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_pressed() -> void:
	queue_free()
	global.player.can_move = true


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/win.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://levels/test_level_t.tscn")
	global.grab_player()
	global.wave = 1
