extends Node3D

const BARCOCHE = preload("res://scenes/barcoche.tscn")

func spawn_barcoche():
	var e
	e = BARCOCHE.instantiate()
	e.position = position
	e.position.x += randi_range(-7, 7)
	e.visible = true
	return e
