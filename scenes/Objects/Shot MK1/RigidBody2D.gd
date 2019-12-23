extends RigidBody2D

export var speed = 500
export var direction = Vector2()

var type = "Shot"
var dmg

func _process(delta):
	
	if direction.length() > 0:
		direction = direction.normalized() * speed
	
	position += direction * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()