extends CanvasLayer

var past_by = 1
var futur_by = 1
var f_items
var p_items
@onready var player := get_tree().get_first_node_in_group("player")



func upgrade_do_shit(p_or_f : int):
	var id
	var scaling
	if p_or_f == 1:
		player.max_hp += 10
		player.current_hp += 10
		id = p_items[1]
		scaling = p_items[0]
	else:
		player.max_hp -= 10
		id = f_items[1]
		scaling = f_items[0]
	
	if id == 0:
		player.damage += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
	if id == 1:
		player.attack_speed -= (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling)/10
	if id == 2:
		player.speed += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling * 100
	if id == 3:
		player.dodge_speed += (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling)/10
	if id == 4:
		player.projectiles_acquired.append(preload("res://entities/projectiles/fire_projectile.tscn"))
	if id == 5:
		player.max_hp += (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling)
	if id == 6:
		player.projectiles_acquired.append(preload("res://entities/projectiles/ice_projectile.tscn"))
	if id == 7:
		player.projectiles_acquired.append(preload("res://entities/projectiles/poison_projectile.tscn"))
	if id == 8:
		player.dash_damage += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
	if id == 9:
		player.bullet_pierce += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
	if id == 10:
		player.bullet_bounce += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.wave != 1:
		past_by = randi_range(1, global.wave - 1)
		futur_by = randi_range(1, 5)
	
	$upgrade/past/Label.text = "Wave " + str(global.wave - past_by)
	p_items = global.grab_loot(global.wave - past_by)
	
	$upgrade/future/Label.text = "Wave " + str(futur_by + global.wave)
	f_items = global.grab_loot(futur_by + global.wave)
	
	#Past item ui set up
	if global.all_upgrades[p_items[1]]["effect"] != 0:
		#$upgrade/past/option_1.text = global.all_upgrades[p_items[1]]["name"] + "\n" + global.all_upgrades[p_items[1]]["desc"] + str(global.all_upgrades[p_items[1]]["effect"] + global.all_upgrades[p_items[1]]["lvl mult"] * p_items[0])
		$upgrade/past/title.text = global.all_upgrades[p_items[1]]["name"]
		$upgrade/past/desc.text = global.all_upgrades[p_items[1]]["desc"] + str(global.all_upgrades[p_items[1]]["effect"] + global.all_upgrades[p_items[1]]["lvl mult"] * p_items[0])
	else:
		$upgrade/past/title.text = global.all_upgrades[p_items[1]]["name"]
		$upgrade/past/desc.text = global.all_upgrades[p_items[1]]["desc"]
	
	
	#$upgrade/past/option_2.text = global.all_upgrades[p_items[2]]["name"] + "\n" + global.all_upgrades[p_items[2]]["desc"] + str(global.all_upgrades[p_items[2]]["effect"])
	#Furute items ui set up
	if global.all_upgrades[f_items[1]]["effect"] != 0:
		$upgrade/future/title.text = global.all_upgrades[f_items[1]]["name"]
		$upgrade/future/desc.text = global.all_upgrades[f_items[1]]["desc"] + str(global.all_upgrades[f_items[1]]["effect"] + global.all_upgrades[f_items[1]]["lvl mult"] * f_items[0])
	else:
		$upgrade/future/title.text = global.all_upgrades[f_items[1]]["name"]
		$upgrade/future/desc.text = global.all_upgrades[f_items[1]]["desc"]
	
	#$upgrade/future/option_2.text = global.all_upgrades[f_items[2]]["name"] + "\n" + global.all_upgrades[f_items[2]]["desc"] + str(global.all_upgrades[f_items[2]]["effect"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_p_option_1_pressed() -> void:
	upgrade_do_shit(1)
	queue_free()
	global.generate_wave(-past_by)


func _on_p_option_2_pressed() -> void:
	queue_free()
	global.generate_wave(-past_by)


func _on_f_option_1_pressed() -> void:
	upgrade_do_shit(2)
	queue_free()
	global.generate_wave(futur_by)


func _on_f_option_2_pressed() -> void:
	queue_free()
	global.generate_wave(futur_by)
