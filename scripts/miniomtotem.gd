"""
Totem que da poderes a los minions.

@author: Martin Soto.
"""
extends Node3D
var health
@onready var hitbox: CollisionShape3D = $CollisionShape3D

func _ready():
	visible = false
	hitbox.disabled = true
	
func setup():
	visible = true
	health=1
	hitbox.disabled = false

func shut_down():
	Global.totems -= 1
	health=0
	hitbox.disabled = true
	visible = false

func take_damage(n: int):
	health = clamp(health-n, 0, 50)
	if health <= 0:
		shut_down()
