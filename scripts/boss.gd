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

#Engine functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$attack_timer.start(attack_speed)
	current_hp = max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if current_hp > max_hp:
		current_hp = max_hp
	
	if current_hp <= 0:
		get_tree().change_scene_to_file("res://ui/game_over.tscn")
	
	if global.player.can_dodge and speed_mod == 1 and can_dodge:
		speed_mod = dodge_speed
		can_dodge = false
		$Area2D.monitorable = true
		$dodge_time.start(dodge_time)
	
	
	if velocity != Vector2.ZERO:
		$player_anims/feet_anim.play("walk")
		$player_anims/head_anim.play("walk")
	else:
		$player_anims/feet_anim.play("idle")
		$player_anims/head_anim.play("idle")
	
	
	#apply movement to player
	velocity = -global.player.player_movement * speed * speed_mod
	
	
	if velocity.x > 0:
		$player_anims.scale.x = 1
	if velocity.x < 0:
		$player_anims.scale.x = -1
	
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
