extends CharacterBody2D

class_name projectile

@export var speed = 3000
@export var damage = 1
var direction = Vector2.ZERO
@export var effects_collection: Array[global.effects] = []




func _process(delta: float) -> void:

	# Handle jump.
	velocity = speed * direction
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		area.get_parent().current_hp -= damage
		
		#		add target to proper debuff group if projectile inflicts an effect
		if effects_collection.has(global.effects.burn):
			area.get_parent().add_to_group("is_burned")
		if effects_collection.has(global.effects.freeze):
			area.get_parent().add_to_group("is_frozen")
		if effects_collection.has(global.effects.slow):
			area.get_parent().add_to_group("is_slowed")
			
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player") and !body.is_in_group("enemy"):
		queue_free()
