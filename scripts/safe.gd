extends Node3D

const SAFE_HEALTH = 100
var health = SAFE_HEALTH
@onready var health_bar: ProgressBar = %HealthBar
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	health_bar.value=10

func remove_health(n: int):
	health -= n
	health_bar.value = health
	if health <= 0:
		animation.play("Open")
		

func _on_timer_timeout() -> void:
	if health >= 0:
		remove_health(10)
