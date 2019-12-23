extends CanvasLayer

signal shoot_now

func _on_Player_life_changed(life):
	$Background/LifeBars/LifeNTime/Life.value = life

func _on_SigmaMain_new_game(life):
	$Background.show()
	$Background2.show()
	$Background/LifeBars/LifeNTime/Life.max_value = life
	$Background/LifeBars/LifeNTime/Life.value = life


func _on_Player_game_over():
	$Background.hide()
	$Background2.hide()

func _on_SigmaMain_score_changed(score):
	$Background2/Status/PointsNName/Points.text = "SC$ %s" %score


func _on_Button_pressed():
	emit_signal("shoot_now")
