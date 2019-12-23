extends Button

func _input(event):
	if event is InputEventScreenTouch:
		emit_signal("pressed")