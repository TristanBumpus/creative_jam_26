extends Node

var seed = RandomNumberGenerator.new()

var all_upgrades = [
	{"name": "Damage up", "desc": "Increases Damage by ", "effect": 2, "lvl mult": 2 },
	{"name": "Attack Speed up", "desc": "Increases attack speed by ", "effect": 2, "lvl mult": 1.5 },
	{"name": "Speed up", "desc": "Increases speed by ", "effect": 2, "lvl mult": 2 },
	{"name": "Dodge time", "desc": "Increases Dodge Time by ", "effect": .2, "lvl mult": .1 },
	{"name": "Fire Ball", "desc": "Cast explosive Fire Balls ", "effect": 1, "lvl mult": 1 },
	{"name": "Max health up", "desc": "Increases Maximum health by ", "effect": 5, "lvl mult": 1.1}
	]

var loot_table = {"commun" : [0,1,2], "rare" : [3, 5], "epic" : [4]}

var loot_pool = []
var enemy_table = ["res://entities/enemies/enemy_charger.tscn","res://entities/enemies/enemy_chaser.tscn"]
var wave = 0
var enemies_to_spawn = []
@onready var player := get_tree().get_first_node_in_group("player")


func grab_loot(level : int):
	return loot_pool[level]


func select_loot(level: int, index : int):
	loot_pool[level][index] *= -1
	return loot_pool[level][index]

func generate_wave(dif):
	wave += 1
	var num_enemies = (2*wave**3)/4 + 2
	print(dif)
	for i in num_enemies:
		enemies_to_spawn += [enemy_table.pick_random()]
	
	var random = randf_range(2,10)
	var enmies_to_change = int(num_enemies / random)
	
	for child in global.enemies_to_spawn:
		var enemy = load(global.enemies_to_spawn.pop_front()).instantiate()
		get_tree().current_scene.add_child(enemy)
		if enmies_to_change > 0:
			enemy.level = wave + dif
			enmies_to_change -= 1
		var random_angle: float = randf_range(0.0, TAU)
		enemy.global_position = player.global_position + Vector2.from_angle(random_angle) * 3500


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
		
		# [level (wave) equivalent, corresponding upgrade (item)]
		loot_pool += [[i] + items]
	print(loot_pool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
