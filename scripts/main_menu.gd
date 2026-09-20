extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func cut_scene():
	get_tree().change_scene_to_file("res://z_cin/cin_01.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/test_level_t.tscn")
	global.grab_player()
	global.wave = 1
