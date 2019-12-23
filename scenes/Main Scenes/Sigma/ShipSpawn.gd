extends Path2D

var is_started = false
var D20
var loaded_enemy
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	
	D20 = int(rand_range(1, 20))

func _process(delta):
	match D20:
		1-5: loaded_enemy = load("res://scenes/Enemie/EnemyMK1.tscn")
		_: loaded_enemy = load("res://scenes/Enemie/EnemyMK1.tscn")
		
	randomize()

func rollD20():
	D20 = int(rand_range(1, 20))

func _on_SigmaMain_new_game(life):
	is_started = true

func _on_Player_game_over():
	is_started = false

func _on_SigmaMain_create_enemy():
	var enemy = loaded_enemy.instance()
	
	$ShipSpawnLocation.set_offset(randi())
	$ShipSpawnLocation.position.x = clamp($ShipSpawnLocation.position.x, 64, screen_size.x - 64)
	
	enemy.position = $ShipSpawnLocation.position
	get_parent().add_child(enemy)
	get_parent().connect("game_over", enemy, "_on_Scene_gameover")
