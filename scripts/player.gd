extends CharacterBody2D

#Variables
var player_movement: Vector2
var mouse_position: Vector2

@export var max_hp: float = 100
@export var current_hp: float = 100
@export var damage: float = 10
@export var speed: float = 10
@export var dodge_speed = 10
var dodge_time = .1
@export var speed_mod = 1
var can_dodge = true
@export var attack_speed = .7
#var projectile = "res://entities/projectils/basic_projectile.tscn"
@export var projectiles_acquired: Array[Resource] = [preload("res://entities/projectiles/basic_projectile.tscn")]
var current_projectile = 0
var dash_damage = 0
var bullet_bounce = 0
var bullet_pierce = 0
var projectile_count_by_type: Dictionary[String, int] = {
	"res://entities/projectiles/basic_projectile.tscn": 1
}


func change_scene():
	$cont/falling_character.visible = true
	$cont/falling_character/AnimationPlayer.play("falling")
	await $cont/falling_character/AnimationPlayer.animation_finished
	$cont/falling_character.visible = false



#Engine functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$attack_timer.start(attack_speed)
	current_hp = max_hp
	change_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if current_hp > max_hp:
		current_hp = max_hp
	
	if current_hp <= 0:
		get_tree().change_scene_to_file("res://ui/game_over.tscn")
	
	if Input.is_action_just_pressed("shift") and speed_mod == 1 and can_dodge:
		speed_mod = dodge_speed
		can_dodge = false
		$Area2D.monitorable = true
		$dodge_time.start(dodge_time)
		$player_anims/dash.emitting = true
		$player_anims/dash2.emitting = true
		$player_anims/dash3.emitting = true
	
	#get input for movement
	player_movement = Vector2(Input.get_action_raw_strength("d") - Input.get_action_raw_strength("a"),Input.get_action_raw_strength("s") - Input.get_action_raw_strength("w")).normalized()
	
	if player_movement != Vector2.ZERO:
		$player_anims/feet_anim.play("walk")
		$player_anims/head_anim.play("walk")
	else:
		$player_anims/feet_anim.play("idle")
		$player_anims/head_anim.play("idle")
	
	#get player direction through mouse position
	mouse_position = get_global_mouse_position()
	#print(mouse_position)
	
	#apply movement to player
	velocity = player_movement * speed * speed_mod
	#print(player_movement)
	
	#apply direction to player
	#look_at(mouse_position)
	
	if velocity.x > 0:
		$player_anims.scale.x = 1
	if velocity.x < 0:
		$player_anims.scale.x = -1
	
	move_and_slide()



func _on_dodge_time_timeout() -> void:
	speed_mod = 1
	$player_anims/dash.emitting = false
	$player_anims/dash2.emitting = false
	$player_anims/dash3.emitting = false
	$Area2D.monitorable = true
	$dodge_cooldown.start()


func _on_dodge_cooldown_timeout() -> void:
	can_dodge = true


func _on_attack_timer_timeout() -> void:
	#var p = load(projectile).instantiate()
	var shouting_projectile := projectiles_acquired[current_projectile]
	#print(shouting_projectile.resource_path)
	#print(projectile_count_by_type[shouting_projectile.resource_path])
	var angle_distance: float = 360 / projectile_count_by_type[shouting_projectile.resource_path]
	var cumulative_angles: float = 0
	#print(angle_distance)
	for i in range(projectile_count_by_type[shouting_projectile.resource_path]):
		var p: projectile = shouting_projectile.instantiate()
		
		current_projectile += 1
		
		if current_projectile >= projectiles_acquired.size():
			current_projectile = 0
		
		p.global_position = global_position
		p.direction = (mouse_position - global_position).normalized()
		p.direction = p.direction.rotated(deg_to_rad(cumulative_angles))
		cumulative_angles += angle_distance
		p.damage = damage
		p.bounce_limit = bullet_bounce
		p.pierce_limit = bullet_pierce
		get_tree().current_scene.add_child(p)
	
	$attack_timer.start(attack_speed)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !$dodge_time.is_stopped() and area.get_parent().is_in_group("enemy"):
		if dash_damage > 0:
			area.get_parent().current_hp -= dash_damage
