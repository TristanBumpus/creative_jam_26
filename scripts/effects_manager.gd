extends Node2D

var active_effects: Array[global.effects] = []
var fire_damage = 1
const FIRE_DAMAGE_TICKS := 5
var fire_damage_ticks_left: int
var target: Node2D


func add_effect(effect: global.effects):
	if !active_effects.has(effect):
		print("adding effect: ", effect)
		active_effects.append(effect)
		apply_effect(effect)
	pass

func remove_effect(effect: global.effects):
	print("removing effect: ", effect)
	if active_effects.has(effect):
		active_effects.erase(effect)
	pass

func apply_effect(effect: global.effects):
	print("applying effect: ", effect)
	match effect:
		global.effects.burn:
			target.add_to_group("is_burned")
			$fire_duration.start()
			target.current_hp -= fire_damage
		global.effects.freeze:
			target.add_to_group("is_frozen")
			$freeze_duration.start()
			target.speed_mod = 0
		global.effects.slow:
			target.add_to_group("is_slowed")
			$slow_duration.start()
			target.speed_mod *= .5
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fire_duration_timeout() -> void:
	if fire_damage_ticks_left > 0:
		fire_damage_ticks_left -= 1
		apply_effect(global.effects.burn)
		$fire_duration.start()
	else:
		remove_effect(global.effects.burn)
		target.remove_from_group("is_burned")
		fire_damage_ticks_left = 5
	pass # Replace with function body.


func _on_freeze_duration_timeout() -> void:
	remove_effect(global.effects.freeze)
	target.remove_from_group("is_frozen")
	target.speed_mod = 1
	pass # Replace with function body.


func _on_slow_duration_timeout() -> void:
	remove_effect(global.effects.slow)
	target.remove_from_group("is_slowed")
	target.speed_mod *= 2
	pass # Replace with function body.
