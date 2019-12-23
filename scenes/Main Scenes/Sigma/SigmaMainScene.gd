extends Node

signal new_game(life)
signal game_over
signal create_enemy
signal score_changed(score)

var base_life = 3
var is_started
var score = 0
var coin_limit
var limit_tag

func _ready():
	$PlayerHUD/Background.hide()
	$PlayerHUD/Background2.hide()
	$PlayerHUD/Background2/Status/PointsNName/Name.text = $Player.player_name
	base_life = $Player.base_life
	
	match limit_tag:
		_: coin_limit = 20
	
	randomize()

func _process(delta):

	if is_started:
		if not $Player.is_dead:
			$PlayerHUD/Background/LifeBars/LifeNTime/Time.value = $Player/ShotTimer.time_left*100
#	else:
#		if Input.is_action_just_pressed("ui_select"):
#			emit_signal("new_game", base_life)

func _on_Player_game_over():
	emit_signal("game_over")
	is_started = false
	$SpawnTimer.stop()
	$TitleScreen.show()

func _on_EnemyMK1_died():
	score += int(rand_range(coin_limit/2, coin_limit))
	emit_signal("score_changed",score)

func _on_SpawnTimer_timeout():
	emit_signal("create_enemy")

func _on_SigmaMain_new_game(life):
	is_started = true
	$Player.position = $PlayerInitPosition.position
	$SpawnTimer.start()

func _on_TitleScreen_new_game():
	emit_signal("new_game", base_life)
	$TitleScreen.hide()
