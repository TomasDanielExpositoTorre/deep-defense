class_name PathFinderEnemy extends CharacterBody3D

# Vida Máxima
var health = 1

# Velocidades de movimiento 
var speed = 1.0
var exalted_speed = 1.1

# Modificadores de ataque
var attack_damage = 1
var attack_speed = 1.0

# Aggro
@onready var target: Marker3D = %Target

func _ready():
	"""
	Dumps the first _physics_process() function call so
	the NavMap finishes synchronization before pathfinding.
	
	Credit: https://github.com/godotengine/godot/issues/84677
	"""
	set_physics_process(false)
	call_deferred("await_mapsync")
	
func await_mapsync():
	await get_tree().physics_frame
	set_physics_process(true)
