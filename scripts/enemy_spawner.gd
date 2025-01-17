extends Node3D

const SHRIMP = preload("res://scenes/shrimp.tscn")
const FISH = preload("res://scenes/shrimp.tscn")
const MINION = preload("res://scenes/shrimp.tscn")
const SOMETHINGELSE = preload("res://scenes/shrimp.tscn")

func spawn_enemy():
	var e = SHRIMP.instantiate()
	e._ready()
	e.position = position
<<<<<<< HEAD
	e.position.x += randf_range(-7.7, 7.7)
=======
>>>>>>> dbece146c15fc0bfb02cdd7f78a31c3345792086
	e.visible = false
	return e
