extends Node2D

signal new_game

func _on_Play_pressed():
	emit_signal("new_game")
