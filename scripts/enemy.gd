extends CharacterBody2D


class_name enemies

@export var max_hp = 1
var current_hp = 1
@export var speed = 1
@export var damage = 1
@export var level = 1

@onready var player := get_tree().get_first_node_in_group("player")

func movement():
	var direction = player.global_position - global_position
	
	velocity = direction * speed



func _ready() -> void:
	max_hp = randi_range(1 * level, 8 * level)

func _process(delta: float) -> void:
	movement()
	
	
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		area.get_parent().current_hp -= damage
		$knock_back.start()
		speed *= -1


func _on_knock_back_timeout() -> void:
	speed *= -1
