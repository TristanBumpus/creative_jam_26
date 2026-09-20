extends CharacterBody2D

class_name projectile

@export var speed = 3000
@export var damage = 1
var direction = Vector2.ZERO
@export var pierce_limit := 0
var pierce_count := 0
@export var bounce_limit := 0
var bounce_count := 0
var bounce_area := Vector2.ONE
@export var can_explode := false

@export var effects_collection: Array[global.effects] = []


func explode_projectile():
	can_explode = false
	speed = 0
	$".".scale *= 5
	#$".".scale = Vector2(2, 2)
	$MeshInstance2D.modulate = Color(1, 0, 0, .5)
	$aoe_duration.start()
	pass



func _ready() -> void:
	#print(effects_collection)
	#print(damage)
	#print(name)
	pass


func _process(delta: float) -> void:

	# Handle jump.
	velocity = speed * direction
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		#print(area.get_parent().current_hp)
		area.get_parent().current_hp -= damage
		
		#		add target to proper debuff group if projectile inflicts an effect
		for effect in effects_collection:
			var effect_manager = area.get_parent().find_child("effects_manager", false)
			if !effect_manager.active_effects.has(effect):
				effect_manager.add_effect(effect)
		
		if can_explode:
			explode_projectile()
		elif pierce_count < pierce_limit:
			pierce_count += 1
		else:
			queue_free()
	
	if area.is_in_group("bounce_area"):
		#print("in bounce area")
		if area.is_in_group("bounce_area_x"):
			#print("bounce area x")
			bounce_area.x = -1
		else:
			bounce_area.x = 1
		if area.is_in_group("bounce_area_y"):
			#print("bounce area y")
			bounce_area.y = -1
		else:
			bounce_area.y = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player") and !body.is_in_group("enemy"):
		
		if can_explode:
			explode_projectile()
		elif bounce_count < bounce_limit:
			#print(bounce_area)
			direction.x *= bounce_area.x
			direction.y *= bounce_area.y
			bounce_count += 1
		else:
			queue_free()


func _on_aoe_duration_timeout() -> void:
	queue_free()
	pass # Replace with function body.
