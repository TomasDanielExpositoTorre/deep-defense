extends Node3D

const MINA = preload("res://scenes/mina.tscn")

func spawn_mina():
	var e = MINA.instantiate()
	e.position = position
	e.position.x += randi_range(-5,5)
	e.position.z += randi_range(-5,5)
	e.position.y += randi_range(-5,5)
	e.visible = true
	return e
