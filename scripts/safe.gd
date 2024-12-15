extends Node3D

var health = 100
var reachable = false
@onready var health_bar: ProgressBar = %HealthBar
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	health_bar.value = health

func remove_health(n: int):
	health -= n
	health_bar.value = health
	if health <= 0:
		animation.play("Open")
		

func _on_timer_timeout() -> void:
	if health >= 0:
		remove_health(10)
