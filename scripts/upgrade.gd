extends CanvasLayer

var past_by = 1
var futur_by = 1
var f_items
var p_items
@onready var player := get_tree().get_first_node_in_group("player")



func upgrade_do_shit(p_or_f : int):
	var id
	if p_or_f == 1:
		id = p_items[0]
	else:
		id = f_items[0]
	
	if id == 0:
		player.damage += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * global.wave
	if id == 1:
		player.attack_speed -= (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * global.wave)/10
	if id == 2:
		player.speed += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * global.wave
	if id == 3:
		player.dodge_speed += (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * global.wave)/10



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.wave != 1:
		past_by = randi_range(1, global.wave)
		futur_by = randi_range(1, 49 - global.wave)
	
	p_items = global.grab_loot(past_by - global.wave)
	f_items = global.grab_loot(futur_by + global.wave)
	
	#Past item ui set up
	$upgrade/past/option_1.text = global.all_upgrades[p_items[1]]["name"] + "\n" + global.all_upgrades[p_items[1]]["desc"] + str(global.all_upgrades[p_items[1]]["effect"] + global.all_upgrades[p_items[1]]["lvl mult"] * global.wave)
	#$upgrade/past/option_2.text = global.all_upgrades[p_items[2]]["name"] + "\n" + global.all_upgrades[p_items[2]]["desc"] + str(global.all_upgrades[p_items[2]]["effect"])
	#Furute items ui set up
	$upgrade/future/option_1.text = global.all_upgrades[f_items[1]]["name"] + "\n" + global.all_upgrades[f_items[1]]["desc"] + str(global.all_upgrades[f_items[1]]["effect"] + global.all_upgrades[f_items[1]]["lvl mult"] * global.wave)
	#$upgrade/future/option_2.text = global.all_upgrades[f_items[2]]["name"] + "\n" + global.all_upgrades[f_items[2]]["desc"] + str(global.all_upgrades[f_items[2]]["effect"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_p_option_1_pressed() -> void:
	upgrade_do_shit(1)
	queue_free()
	global.generate_wave()


func _on_p_option_2_pressed() -> void:
	queue_free()
	global.generate_wave()


func _on_f_option_1_pressed() -> void:
	upgrade_do_shit(2)
	queue_free()
	global.generate_wave()


func _on_f_option_2_pressed() -> void:
	queue_free()
	global.generate_wave()
