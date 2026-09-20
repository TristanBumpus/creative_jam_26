extends Node

var seed = RandomNumberGenerator.new()

var all_upgrades = [
	{"name": "Damage up", "desc": "Increases Damage by ", "effect": 2, "lvl mult": 2, "img_path": "res://assets/upgrades/damage.png" },
	{"name": "Attack Speed up", "desc": "Increases attack speed by ", "effect": 2, "lvl mult": 1.5, "img_path": "res://assets/upgrades/attack_speed.png" },
	{"name": "Speed up", "desc": "Increases speed by ", "effect": 2, "lvl mult": 2, "img_path": "res://assets/upgrades/speed.png" },
	{"name": "Dodge time", "desc": "Increases Dodge Time by ", "effect": .2, "lvl mult": .1, "img_path": "res://assets/upgrades/dodge_time.png" },
	{"name": "Fire Ball", "desc": "Adds an explosive Fire Balls to your cast ", "effect": 0, "lvl mult": .1, "img_path": "res://assets/upgrades/fire_ball.png" },
	{"name": "Max Health Up", "desc": "Increases Maximum health by ", "effect": 5, "lvl mult": .5, "img_path": "res://assets/upgrades/health.png" },
	{"name": "Ice Ball", "desc": "Adds a ball of Ice to  your cast", "effect": 0, "lvl mult": .1, "img_path": "res://assets/upgrades/ice_ball.png" },
	{"name": "Posion Ball", "desc": "Adds a Toxic glob to your cast ", "effect": 0, "lvl mult": .1, "img_path": "res://assets/upgrades/poison_ball.png" },
	{"name": "Damage Dash", "desc": "Makes dash deal more damage ", "effect": 5, "lvl mult": 2, "img_path": "res://assets/upgrades/damage_dash.png" },
	{"name": "Piercing Shot", "desc": "Makes your spells pierce enemies ", "effect": 1, "lvl mult": 1, "img_path": "res://assets/upgrades/piercing.png" },
	{"name": "Bouncy Magic", "desc": "Makes your spells bouncy ", "effect": 1, "lvl mult": 1, "img_path": "res://assets/upgrades/rebound.png" }
	]

enum effects {
	poison,
	slow,
}

var loot_table = {"commun" : [0,1,5,8], "rare" : [3,4,6,7,9,10]}
#var loot_table = {"commun" : [4,6,7], "rare" : [9, 10]}

var loot_pool = []
var enemy_table = [
	"res://entities/enemies/enemy_charger.tscn",
	"res://entities/enemies/enemy_chaser.tscn",
	"res://entities/enemies/gobline.tscn",
	"res://entities/enemies/knight.tscn"
	]
var wave = 1
var enemies_to_spawn = []
@onready var player := get_tree().get_first_node_in_group("player")


func grab_loot(level : int):
	return loot_pool[level]


func select_loot(level: int, index : int):
	loot_pool[level][index] *= -1
	return loot_pool[level][index]

func generate_wave(dif):
	wave += 1
	var num_enemies = (2*wave**2)/4 + 2
	for i in num_enemies:
		enemies_to_spawn += [enemy_table.pick_random()]
	
	var random = randf_range(2,10)
	var enmies_to_change = int(num_enemies / random) + 1
	
	for child in global.enemies_to_spawn:
		await get_tree().process_frame
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
		if r <= 60:
			rarity = "commun"
		else:
			rarity = "rare"
			#if items[0] != items[1]:
				#break
			#else:
				#items = []
		
		# [level (wave) equivalent, corresponding upgrade (item)]
		loot_pool += [[i,  loot_table[rarity].pick_random()]]

func grab_player():
	await get_tree().scene_changed
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
