extends CharacterBody2D

class_name projectile

@export var speed = 3000
@export var damage = 1
var direction = Vector2.ZERO
@export var effects_collection: Array[global.effects] = []



func _ready() -> void:
	#print(effects_collection)
	#print(damage)
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
			
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player") and !body.is_in_group("enemy"):
		queue_free()
