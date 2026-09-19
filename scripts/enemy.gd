extends CharacterBody2D


class_name enemies

@export var max_hp = 1
@export_enum("chaser","charger") var type = "chaser"
var current_hp = 1
@export var speed = 1
@export var damage = 1
@export var level = 0
@export var attack_range = 128
@export var dash_speed = 5
var speed_mod: float = 1
var direction = Vector2.ZERO

@onready var player := get_tree().get_first_node_in_group("player")



func movement():
	if speed_mod <= 1:
		direction = (player.global_position - global_position).normalized()
	
	velocity = direction * speed * speed_mod

func charge_attach():
	if global_position.distance_to(player.global_position) <= attack_range and $knock_back.is_stopped() and $charger.is_stopped() and $charge.is_stopped():
		speed_mod = 0
		$charge.start()



func _ready() -> void:
	if level == 0:
		level = global.wave
	max_hp = randi_range(1 * level, max_hp * level)
	damage = randi_range(1 * level, damage * level)
	speed = randi_range(5 * level, speed * level) + 500

func _process(delta: float) -> void:
	if current_hp <= 0:
		queue_free()
	if type == "charger":
		
		charge_attach()
	
	movement()
	
	
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		area.get_parent().current_hp -= damage
		$knock_back.start(.2)
		if type != "charger":
			speed_mod = -1
		else:
			speed_mod = -1
			$cooldown.start()


func _on_knock_back_timeout() -> void:
	if $cooldown != null and $cooldown.is_stopped():
		speed_mod = 1
	else:
		speed_mod = 0


func _on_charger_timeout() -> void:
	$knock_back.start(.2)
	speed_mod = -1


func _on_charge_timeout() -> void:
	$charger.start()
	speed_mod = dash_speed


func _on_cooldown_timeout() -> void:
	speed_mod = 1
