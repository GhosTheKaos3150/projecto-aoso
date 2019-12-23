extends Area2D

signal life_changed(life)
signal game_over

var Shot
var shot_type
var shot_is_enabled

export var base_life = 3
export var speed = 100

var screen_size
var touch_position

var player_name
var player_life
var atack
var defense
var is_dead
var can_shot
var type = "Player"


func _ready():
	screen_size = get_viewport_rect().size # Setting the screen size
	
	player_life = base_life
	
	player_name = "Maverik 28xx"
	atack = 1
	defense = 0
	is_dead = false
	can_shot = false
	touch_position = position
	
	#Configuring the Player Shot
	match shot_type:
		1: Shot = load("res://scenes/Objects/Shot MK1/Shot_MK1.tscn")
		_: Shot = load("res://scenes/Objects/Shot MK1/Shot_MK1.tscn")

func _process(delta):
	
	if is_dead:
			hide()
			emit_signal("game_over")

func _unhandled_input(event):
	var direction = Vector2()
	
	if event is InputEventScreenDrag:
		position.x = event.position.x
		position.x = clamp(position.x, 64, screen_size.x-64)
			
	if event is InputEventScreenTouch and event.is_pressed():
		if shot_is_enabled and can_shot:
			create_shot()
		

func create_shot():
	var direction = Vector2()
	
	var shot = Shot.instance()
	shot.dmg = atack
	shot.direction.y -= 1
	shot.position.y = position.y - 64
	shot.position.x = position.x
	
	get_parent().add_child(shot)
	$SoundShot.play()
	shot_is_enabled = false
	$ShotTimer.start()

func _on_Player_area_entered(area):
	
	player_life -= 1
	emit_signal("life_changed",player_life)
	
	if player_life <= 0:
		$AnimatedSprite.play("death")
		is_dead = true
	else:
		$AnimatedSprite.play("hitted")
	area.queue_free()


func _on_Player_body_entered(body):

	if body.type == "Healler":
		player_life += 1
		$SoundLifeUp.play()
		
	elif body.type == "Shot":
		player_life -= body.dmg
		$SounfHit.play()
		
	else:
		player_life -= 1
		$SounfHit.play()
		
	emit_signal("life_changed",player_life)
	
	if player_life <= 0:
		$AnimatedSprite.play("death")
		$SoundKill.play()
		is_dead = true
		
	else:
		$AnimatedSprite.play("hitted")
		
	body.queue_free()

func _on_ShotTimer_timeout():
	shot_is_enabled = true

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "idle":
		if is_dead:
			hide()
			emit_signal("game_over")
		else:
			$AnimatedSprite.play("idle")


func _on_SigmaMain_new_game(life):
	is_dead = false
	can_shot = true
	player_life = base_life
	$AnimatedSprite.play("idle")
	show()


func _on_Player_game_over():
	is_dead = true
	can_shot = false
	hide()
