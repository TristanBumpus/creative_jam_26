extends Node

var seed = RandomNumberGenerator.new()

var loot_table = {"commun" : [], "rare" : [], "epic" : []}
var all_upgrades = []
var loot_pool = []


func grab_loot(level : int):
	return loot_pool[level]


func select_loot(level: int, index : int):
	return loot_pool[level].pop_at(index)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(50):
		var items = []
		for i2 in range(3):
			var r = seed.randi_range(1,100)
			var rarity = "commun"
			if r >= 1:
				rarity = "commun"
			loot_table["commun"].pick_random()
			items += [loot_table["commun"].pick_random()]
		
		loot_pool += [[i] + items]
	print(loot_pool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
