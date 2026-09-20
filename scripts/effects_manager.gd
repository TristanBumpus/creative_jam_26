extends Node2D

var active_effects: Array[global.effects] = []
var poison_damage = 1
const POISON_DAMAGE_TICKS := 5
var poison_damage_ticks_left := POISON_DAMAGE_TICKS
var target: Node2D


func add_effect(effect: global.effects):
	if !active_effects.has(effect):
		#print("adding effect: ", effect)
		active_effects.append(effect)
		apply_effect(effect)
	pass

func remove_effect(effect: global.effects):
	#print("removing effect: ", effect)
	if active_effects.has(effect):
		active_effects.erase(effect)
	pass

func apply_effect(effect: global.effects):
	#print("applying effect: ", effect)
	match effect:
		global.effects.slow:
			#print("slow")
			target.add_to_group("is_slowed")
			target.speed_mod *= .25
			#print(target.speed_mod)
			$slow_duration.start()
		global.effects.poison:
			#print("burn")
			target.add_to_group("is_poisoned")
			#print("target hp before damage tick: ", target.current_hp)
			target.current_hp -= poison_damage
			#print("target hp after damage tick: ", target.current_hp)
			$poison_duration.start()
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_poison_duration_timeout() -> void:
	if poison_damage_ticks_left > 0:
		poison_damage_ticks_left -= 1
		apply_effect(global.effects.poison)
		$poison_duration.start()
	else:
		remove_effect(global.effects.poison)
		target.remove_from_group("is_poisoned")
		poison_damage_ticks_left = POISON_DAMAGE_TICKS
	pass # Replace with function body.


func _on_slow_duration_timeout() -> void:
	remove_effect(global.effects.slow)
	target.remove_from_group("is_slowed")
	target.speed_mod *= 4
	pass # Replace with function body.
