extends Area2D

signal died
signal hitted

export var life = 3
var atack
var defense
var Shot
var shot_type
var is_dead
export var speed = 100

func _ready():

	connect("died", get_parent(), "_on_EnemyMK1_died")
	
	atack = 1
	defense = 0
	
	$LifeBar.max_value = life
	$LifeBar.value = life
	
	match shot_type:
		1: Shot = load("res://scenes/Objects/Shot MK1/Shot_MK1.tscn")
		_: Shot = load("res://scenes/Objects/Shot MK1/Shot_MK1.tscn")

func _process(delta):
	var direction = Vector2()
	
	direction.y += 1
	
	if direction.length() > 0:
		direction = direction.normalized() * speed
	
	position += direction * delta

func _create_shot(posX, posY):
	var shot = Shot.instance()
	
	shot.dmg = atack
	shot.direction.y += 1
	shot.position.x = posX
	shot.position.y = posY
	get_parent().add_child(shot)
	$SoundShot.play()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_ShotTimer_timeout():
	if not is_dead:
		_create_shot(position.x+30, position.y+64)
		_create_shot(position.x-30, position.y+64)


func _on_EnemyMK1_hitted():
	$LifeBar.value -= 1
	$SoundHit.play()

func _on_EnemyMK1_body_entered(body):
	body.queue_free()
	
	if body.direction.y < 0:
		life -= body.dmg
		emit_signal("hitted")
	else:
		return
	
	if life == 0:
		$Sprite.play("death")
		is_dead = true
	else:
		$Sprite.play("hitted")


func _on_Sprite_animation_finished():
	if  life == 0:
		emit_signal("died")
		$SoundDeath.play()
		queue_free()
	else:
		$Sprite.play("running")
		
func _on_Scene_gameover():
	queue_free()