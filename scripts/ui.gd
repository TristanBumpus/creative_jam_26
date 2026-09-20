extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#$TextureProgressBar.value = global.player.current_hp
	#$TextureProgressBar/TextureRect.rotation_degrees = -(global.player.current_hp / global.player.max_hp) * 100 * 3.6
	var t = create_tween()
	if global.player.current_hp != $TextureProgressBar.value:
		t.tween_property($TextureProgressBar,"value",global.player.current_hp,.1)
		t.parallel().tween_property($TextureProgressBar/TextureRect,"rotation_degrees",-(global.player.current_hp / global.player.max_hp) * 100 * 3.6,.1)
	
	$TextureProgressBar.max_value = global.player.max_hp
