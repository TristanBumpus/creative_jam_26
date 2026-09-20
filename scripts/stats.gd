extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("tab"):
		visible = !visible
		var t = create_tween()
		if position.x == 0:
			t.tween_property(self,"position.x", 5000, .2)
		else:
			t.tween_property(self,"position.x", 0, .2)
	
	$Label.text = "Hp: " + str(global.player.max_hp) + "\n
	" + "Damage: " + str(global.player.damage) + "\n
	" + "Attack Speed: " + str(global.player.attack_speed) + "\n
	" + "Dodge Time: " + str(global.player.dodge_time * 10) + "\n
	" + "Bullet Bounces: " + str(global.player.bullet_bounce) + "\n
	" + "Bullet Piercing: " + str(global.player.bullet_pierce) + "\n
	" + "Dash Damage: " + str(global.player.dash_damage)
