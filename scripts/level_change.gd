extends Node2D

@export var width = 512
@export var height = 352

@export var door_top: StaticBody2D
@export var door_bottom : StaticBody2D
@export var door_right : StaticBody2D
@export var door_left : StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var level = load("res://levels/level_1.tscn").instantiate()
		
		
		get_tree().current_scene.add_child(level)
		
		print(global.player.global_position.y <= global_position.y - height/1.2)
		
		if global.player.global_position.y <= global_position.y - height/2.2:
			print("Top")
			level.door_bottom.locked = true
			level.global_position = global_position + Vector2(0,-height*2)
			global.player.global_position.y = level.global_position.y
		
		if global.player.global_position.y >= global_position.y + height/2.2:
			print("Bottom")
			level.door_top.locked = true
			level.global_position = global_position + Vector2(0,height*2)
			global.player.global_position = global_position + Vector2(0,height + 32)
		
		if global.player.global_position.x <= global_position.x - width/2:
			print("Left")
			level.door_right.locked = true
			level.global_position = global_position + Vector2(width*2,0)
			global.player.global_position = global_position + Vector2(width + 32,0)
		
		if global.player.global_position.x >= global_position.x + width/2:
			print("Right")
			level.door_left.locked = true
			level.global_position = global_position + Vector2(-width*2,0)
			global.player.global_position = global_position + Vector2(-width - 32,0)
		
		$"../Camera2D".global_position = level.global_position
		queue_free()
		
		#level.global_position = global_position + Vector2(width/2,height/2)


func _on_up_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var level = load("res://levels/level_1.tscn").instantiate()
		
		
		get_tree().current_scene.add_child(level)
		
		level.door_bottom.locked = true
		level.global_position = global_position + Vector2(0,-height*2)
		global.player.global_position.y = level.door_bottom.global_position.y - 100
		
		
		
		$"../Camera2D".global_position = level.global_position
		queue_free()


func _on_down_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var level = load("res://levels/level_1.tscn").instantiate()
		
		
		get_tree().current_scene.add_child(level)
		
		level.door_top.locked = true
		level.global_position = global_position + Vector2(0,height*2)
		global.player.global_position.y = level.door_top.global_position.y + 100
		
		
		
		$"../Camera2D".global_position = level.global_position
		queue_free()


func _on_left_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var level = load("res://levels/level_1.tscn").instantiate()
		
		
		get_tree().current_scene.add_child(level)
		
		level.door_right.locked = true
		level.global_position = global_position + Vector2(-width*2,0)
		global.player.global_position.x = level.door_right.global_position.x - 100
		
		
		
		$"../Camera2D".global_position = level.global_position
		queue_free()


func _on_right_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var level = load("res://levels/level_1.tscn").instantiate()
		
		
		get_tree().current_scene.add_child(level)
		
		level.door_left.locked = true
		level.global_position = global_position + Vector2(width*2,0)
		global.player.global_position.x = level.door_left.global_position.x + 100
		
		
		
		$"../Camera2D".global_position = level.global_position
		queue_free()
