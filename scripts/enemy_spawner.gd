extends Node3D

const SHRIMP = preload("res://scenes/shrimp.tscn")
const FISH = preload("res://scenes/shrimp.tscn")
const MINION = preload("res://scenes/shrimp.tscn")
const SOMETHINGELSE = preload("res://scenes/shrimp.tscn")

func spawn_enemy():
	var e = SHRIMP.instantiate()
	e._ready()
	e.position = position
	e.visible = false
	return e
