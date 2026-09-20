extends Control

var master = 5
var music = 5
var sfx = 5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var linear_val = master / 10.0
	
	if linear_val <= 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		# Convert linear scale to decibels for the audio server
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(linear_val))
	
	
	if linear_val <= 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), false)
		# Convert linear scale to decibels for the audio server
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(linear_val))
	
	if linear_val <= 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), false)
		# Convert linear scale to decibels for the audio server
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear_to_db(linear_val))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !get_tree().paused:
		position.x = 10000000
	else:
		position.x = 0
	
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = !get_tree().paused


func _on_fullscreen_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_master_pressed() -> void:
	$master.text = "Master " + str(master)
	master += 1
	if master > 10:
		master = 0
	
	AudioServer.get_bus_index("Master")
	
	var linear_val = master / 10.0
	
	if linear_val <= 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		# Convert linear scale to decibels for the audio server
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(linear_val))


func _on_music_pressed() -> void:
	
	$music.text = "Music " + str(music)
	
	music += 1
	if music > 10:
		music = 0
	
	AudioServer.get_bus_index("Master")
	
	var linear_val = music / 10.0
	
	if linear_val <= 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), false)
		# Convert linear scale to decibels for the audio server
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(linear_val))


func _on_sfx_pressed() -> void:
	
	$sfx.text = "SFX " + str(sfx)
	
	sfx += 1
	if sfx > 10:
		sfx = 0
	
	AudioServer.get_bus_index("Master")
	
	var linear_val = sfx / 10.0
	
	if linear_val <= 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), false)
		# Convert linear scale to decibels for the audio server
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear_to_db(linear_val))


func _on_resume_pressed() -> void:
	get_tree().paused = false
