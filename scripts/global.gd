extends Node

var seed = RandomNumberGenerator.new()

var all_upgrades = [
	{"name" : "Damage up", "desc":"Increases Damage by ", "effect": 2, "lvl mult" : 2 },
	{"name" : "Attack Speed up", "desc":"Increases attack speed by ", "effect": 2, "lvl mult" : 1.5 },
	{"name" : "Speed up", "desc":"Increases speed by ", "effect": 2, "lvl mult" : 2 },
	{"name" : "Dodge time", "desc":"Increases Dodge Time by ", "effect": .2, "lvl mult" : .1 },
	{"name" : "Fire Ball", "desc":"Cast explosive Fire Balls ", "effect": 1, "lvl mult" : 1 },
	]

var loot_table = {"commun" : [0,1,2], "rare" : [3], "epic" : [4]}

var loot_pool = []
var enemy_table = ["res://entities/enemies/enemy_charger.tscn","res://entities/enemies/enemy_chaser.tscn"]
var wave = 1
var enemies_to_spawn = []
@onready var player := get_tree().get_first_node_in_group("player")


func grab_loot(level : int):
	return loot_pool[level]


func select_loot(level: int, index : int):
	loot_pool[level][index] *= -1
	return loot_pool[level][index]

func generate_wave():
	wave += 1
	var num_enemies = (5*wave**3)/4 + 2
	
	for i in num_enemies:
		enemies_to_spawn += [enemy_table.pick_random()]
	
	for child in global.enemies_to_spawn:
			var enemy = load(global.enemies_to_spawn.pop_front()).instantiate()
			get_tree().current_scene.add_child(enemy)
			enemy.global_position = player.global_position + Vector2(500+randi_range(1,100),200)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(50):
		var items = []
		#while true:
			#for i2 in range(2):
		var r = seed.randi_range(1,100)
		var rarity = "commun"
		if r <= 50:
			rarity = "commun"
		elif r > 50 and r <= 95:
			rarity = "rare"
		else:
			rarity = "epic" 
		items += [loot_table[rarity].pick_random()]
			#if items[0] != items[1]:
				#break
			#else:
				#items = []
		
		loot_pool += [[i] + items]
	print(loot_pool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
