extends Node3D

const SHRIMP = preload("res://scenes/shrimp.tscn")
const FISH = preload("res://scenes/shrimp.tscn")
const MINION = preload("res://scenes/miniom.tscn")

func spawn_enemy():
	var i = randi_range(1,2)
	var e
	print(i)
	if i == 1:
		e = SHRIMP.instantiate()
	else:
		e = MINION.instantiate()
	
	e._ready()
	e.position = position
	e.position.x += randf_range(-7.7, 7.7)
	e.visible = false
	return e
