extends CharacterBody2D

#Variables

@export var max_hp: float = 100
@export var current_hp: float = 100
@export var damage: float = 10
@export var speed: float = 10
@export var dodge_speed = 10
var dodge_time = .1
@export var speed_mod = 1
var can_dodge = true
@export var attack_speed = .7
@export var projectiles_acquired: Array[Resource] = [preload("res://entities/projectiles/basic_projectile.tscn")]
var current_projectile = 0
var dash_damage = 0
var bullet_bounce = 0
var bullet_pierce = 0
var phase = 1


#Engine functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global.boss_upgrades)
	for item in global.boss_upgrades:
		var scaling = item[0]
		var id = item[1]
		
		if id == 0:
			damage += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
		if id == 1:
			attack_speed -= (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling)/10
		if id == 2:
			speed += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling * 100
		if id == 3:
			dodge_speed += (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling)/10
		if id == 4:
			projectiles_acquired.append(preload("res://entities/projectiles/fire_projectile.tscn"))
		if id == 5:
			max_hp += (global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling)
		if id == 6:
			projectiles_acquired.append(preload("res://entities/projectiles/ice_projectile.tscn"))
		if id == 7:
			projectiles_acquired.append(preload("res://entities/projectiles/poison_projectile.tscn"))
		if id == 8:
			dash_damage += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
		if id == 9:
			bullet_pierce += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
		if id == 10:
			bullet_bounce += global.all_upgrades[id]["effect"] + global.all_upgrades[id]["lvl mult"] * scaling
	
	
	$attack_timer.start(attack_speed)
	current_hp = max_hp
	$time_shift.start(randf_range(1,5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if current_hp > max_hp:
		current_hp = max_hp
	
	if current_hp <= 0:
		queue_free()
		var e = load("res://z_cin/cin_01-1.tscn").instantiate()
		get_tree().current_scene.add_child(e)
		global.player.can_move = false
	
	if global.player.can_dodge and speed_mod == 1 and can_dodge:
		speed_mod = dodge_speed
		can_dodge = false
		$Area2D.monitorable = true
		$dodge_time.start(dodge_time)
	
	
	if velocity != Vector2.ZERO:
		$evil_anims/feet_anim.play("walk")
		$evil_anims/head_anim.play("walk")
	else:
		$evil_anims/feet_anim.play("idle")
		$evil_anims/head_anim.play("idle")
	
	
	#apply movement to player
	if phase == 1:
		velocity = -global.player.player_movement * speed * speed_mod
	else:
		velocity = speed * Vector2(randf(),randf()).normalized() * speed_mod
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
	
	if velocity.x > 0:
		$evil_anims.scale.x = 1
	if velocity.x < 0:
		$evil_anims.scale.x = -1
	
	move_and_slide()



func _on_dodge_time_timeout() -> void:
	speed_mod = 1
	$Area2D.monitorable = true
	$dodge_cooldown.start()


func _on_dodge_cooldown_timeout() -> void:
	can_dodge = true


func _on_attack_timer_timeout() -> void:
	#var p = load(projectile).instantiate()
	var p = projectiles_acquired[current_projectile].instantiate()
	
	current_projectile += 1
	
	if current_projectile >= projectiles_acquired.size():
		current_projectile = 0
	
	p.target = "player"
	p.self_target = "enemy"
	p.global_position = global_position
	p.direction = ((global.player.position + global.player.player_movement * global_position.distance_to(global.player.global_position)) - global_position).normalized()
	p.damage = damage
	p.bounce_limit = bullet_bounce
	p.pierce_limit = bullet_pierce
	get_tree().current_scene.add_child(p)
	
	$attack_timer.start(attack_speed)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !$dodge_time.is_stopped() and area.get_parent().is_in_group("enemy"):
		if dash_damage > 0:
			area.get_parent().current_hp -= dash_damage


func _on_time_shift_timeout() -> void:
	phase += 1
	if phase > 2:
		phase = 1
	$time_shift.start(randf_range(1,5))
