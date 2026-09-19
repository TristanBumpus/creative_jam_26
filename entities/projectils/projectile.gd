extends CharacterBody2D


var speed = 300
var damage = 1
var direction = Vector2.ZERO



func _process(delta: float) -> void:

	# Handle jump.
	velocity = speed * direction
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		area.get_parent().current_hp -= damage
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player") and !body.is_in_group("enemy"):
		queue_free()
