extends Node3D

const SHRIMP = preload("res://scenes/shrimp.tscn")
const FISH = preload("res://scenes/pez.tscn")
const MINION = preload("res://scenes/miniom.tscn")

func spawn_enemy():
	var i = randi_range(1,3)
	var e
	if i == 1:
		e = SHRIMP.instantiate()
	elif i == 2:
		e = MINION.instantiate()
	else:
		e = FISH.instantiate()
	e._ready()
	e.position = position
	
	if i == 3:
		e.position.y = 1.25
		
	e.position.x += randf_range(-7.7, 7.7)
	e.visible = false
	return e
