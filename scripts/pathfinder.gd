"""
Clase base para enemgios en el juego. Contiene los parámetros compartidos
entre todos los enemigos, incluido el target al que intentarán atacar y
sobre el que harán pathfinding.

Se asume que todas las clases que hereden de este script tendrán incluido
un nodo NavigationAgent3D para realizar el pathfinding.

@author: Tomás Daniel Expósito Torre
"""
class_name PathFinderEnemy extends CharacterBody3D

# Estadísticas de Enemigo
var health = 1
var enraged = false

var speed = 1.0
var damage = 1.0
var atk_speed = 1.0

var ex_speed = 1.1
var ex_damage = 1.1
var ex_atk_speed = 1.1

# Pathfinding
@onready var target = %Safe
@onready var player = %Player

var attacking = false

func _ready():
	"""
	Evita llamar al método _physics_process() hasta que se haga
	la vinculación del mapa (esencialmente tira el primer frame).
	
	Credito: https://github.com/godotengine/godot/issues/84677
	"""
	set_physics_process(false)
	call_deferred("await_mapsync")
	
func await_mapsync():
	"""
	Habilita la función _physics_process() nuevamente.
	"""
	await get_tree().physics_frame
	set_physics_process(true)
	
func enrage():
	enraged = true
	target = player
