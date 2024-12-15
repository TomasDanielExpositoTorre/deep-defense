"""
La caja fuerte que contiene la formula secreta que
debemos proteger.

@author: Tomás Daniel Expósito Torre.
"""
extends Node3D

var health = 100
var open = false
@onready var health_bar: ProgressBar = %HealthBar
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var damaged: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	health_bar.value = health

func take_damage(n: int):
	if health > 0:
		health = clamp(health-n,0, 100)
		health -= n
		health_bar.value = health
		damaged.play()
		if health <= 0 and not open:
			open = true
			animation.play("Open")
