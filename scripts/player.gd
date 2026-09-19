extends CharacterBody2D

#Variables
var player_movement: Vector2
var mouse_position: Vector2

@export var max_hp: float = 100
@export var current_hp: float = 100
@export var damage: float = 10
@export var speed: float = 10
@export var dodge_speed = 5
var dodge_time = .1
@export var speed_mod = 1
var can_dodge = false
@export var attack_speed = .7
var projectile = "res://entities/projectils/basic_projectile.tscn"


#Engine functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$attack_timer.start(attack_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("shift") and speed_mod == 1:
		speed_mod = dodge_speed
		$dodge_time.start(dodge_time)
	
	#get input for movement
	player_movement = Vector2(Input.get_action_raw_strength("d") - Input.get_action_raw_strength("a"),Input.get_action_raw_strength("s") - Input.get_action_raw_strength("w")).normalized()
	
#	get player direction through mouse position
	mouse_position = get_global_mouse_position()
	#print(mouse_position)
	
#	apply movement to player
	velocity = player_movement * speed * speed_mod
	#print(player_movement)
	
#	apply direction to player
	#look_at(mouse_position)
	
	move_and_slide()


func _on_dodge_time_timeout() -> void:
	speed_mod = 1
	$dodge_cooldown.start()


func _on_dodge_cooldown_timeout() -> void:
	can_dodge = true


func _on_attack_timer_timeout() -> void:
	var p = load(projectile).instantiate()
	
	get_tree().current_scene.add_child(p)
	p.global_position = global_position
	p.direction = (mouse_position - global_position).normalized()
	p.damage = damage
	
	$attack_timer.start(attack_speed)
