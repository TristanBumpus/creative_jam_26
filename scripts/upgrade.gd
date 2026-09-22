extends CanvasLayer

var past_by = 1
var futur_by = 1
var f_items
var p_items
@onready var player := get_tree().get_first_node_in_group("player")
var direction = -1
var levels = ["res://levels/level_2.tscn","res://levels/level_3.tscn","res://levels/level_4.tscn"]



func upgrade_do_shit(p_or_f : int):
	var id
	var boss_item
	var scaling
	if p_or_f == 1:
		player.current_hp += player.max_hp /5
		id = p_items[1]
		boss_item = f_items[1]
		scaling = p_items[0]
	else:
		id = f_items[1]
		boss_item = f_items[1]
		scaling = f_items[0]
	
	global.boss_upgrades += [[scaling,boss_item]]
	
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
	
	if id in [4, 6, 7]:
		if player.projectiles_acquired[-1].resource_path in player.projectile_count_by_type:
			player.projectile_count_by_type[player.projectiles_acquired[-1].resource_path] += 1
		else:
			player.projectile_count_by_type[player.projectiles_acquired[-1].resource_path] = 1
	

func change_level():
	var level = load(levels.pick_random()).instantiate()
	
	
	get_tree().current_scene.add_child(level)
	
	level.global_position = global.player.global_position + Vector2(-50000*2,0)
	global.player.global_position = level.global_position
	
	$"../Camera2D".global_position = level.global_position
	
	global.player.change_scene()



func _ready() -> void:
	p_items = global.grab_loot(global.wave - past_by)
	f_items = global.grab_loot(futur_by + global.wave)
	if global.wave != 1:
		while true:
			past_by = randi_range(1, global.wave - 1)
			futur_by = randi_range(1, 5)
			p_items = global.grab_loot(global.wave - past_by)
			f_items = global.grab_loot(futur_by + global.wave)
			if f_items[1] != p_items[1]:
				break
	
	
	$upgrade/past/Label.text = "Wave " + str(global.wave - past_by)
	
	$upgrade/future/Label.text = "Wave " + str(futur_by + global.wave)
	
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
	
	$upgrade/past/TextureRect.texture = load(global.all_upgrades[p_items[1]]["img_path"])
	$upgrade/future/TextureRect.texture = load(global.all_upgrades[f_items[1]]["img_path"])
	
	
	#$upgrade/future/option_2.text = global.all_upgrades[f_items[2]]["name"] + "\n" + global.all_upgrades[f_items[2]]["desc"] + str(global.all_upgrades[f_items[2]]["effect"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("click"):
		#$choose_orbs_anim/general_anim.
		var anim = $choose_orbs_anim/general_anim.get_animation("intro")
		$choose_orbs_anim/general_anim.seek(anim.length, true)
		$upgrade.visible = true
	
	
	if $upgrade/option_1.is_hovered() and direction != 1:
		direction = 1
		$choose_orbs_anim/interact_anim.play("left")
		$upgrade/future.visible = false
		$upgrade/past.visible = true
	
	if $upgrade/option_2.is_hovered() and direction != 2:
		direction = 2
		$choose_orbs_anim/interact_anim.play("right")
		$upgrade/future.visible = true
		$upgrade/past.visible = false
	
	if direction == 1:
		$choose_orbs_anim/orb_l/Portal.rotation_degrees += 1
	if direction == 2:
		$choose_orbs_anim/orb_r/Portal.rotation_degrees += 1


func _on_p_option_1_pressed() -> void:
	upgrade_do_shit(1)
	change_level()
	queue_free()


func _on_p_option_2_pressed() -> void:
	queue_free()


func _on_f_option_1_pressed() -> void:
	upgrade_do_shit(2)
	change_level()
	queue_free()


func _on_f_option_2_pressed() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$upgrade.visible = true
