extends Node3D

var health = 100
var open = false
@onready var health_bar: ProgressBar = %HealthBar
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	health_bar.value = health

func take_damage(n: int):
	health -= n
	health_bar.value = health
	if health <= 0 and not open:
		open = true
		animation.play("Open")
