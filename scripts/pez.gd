"""
Un camarón muy simpático. Tiene un area de detección moderada,
se mueve por el suelo y ataca cuerpo a cuerpo con un hacha.

@author: Tomás Daniel Expósito Torre.
"""
extends PathFinderEnemy

@onready var nav: NavigationAgent3D = $Navigation
var safe
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var damage_range: Area3D = $DamageRange
@onready var attack_range: Area3D = $AttackRange
@onready var sounds: Node3D = $Sounds
const type = "pez"

# ------------------------------------------------------------------------------
# ----------------------------- FUNCIONES NORMALES -----------------------------
# ------------------------------------------------------------------------------
func _ready():
	super._ready()
	# Parámetros normales
	health = 5
	damage = 2
	speed = 3.5
	atk_speed = 1.7
	
func _physics_process(_delta: float) -> void:
	# Do not move while attacking
	if attacking or not target:
		return

	# Look at target
	nav.target_position = target.global_position
	look_at(nav.target_position)
	rotation.y += 30
	rotation.x = 0
	rotation.z = 0
	# Spam attack if in range
	if target in attack_range.get_overlapping_bodies():
		attack(target)
	# Walk to target with pathfinding
	else:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = direction * (speed if not enraged else ex_speed)
		animation.play("Moviendo cola")
		move_and_slide()


# ------------------------------------------------------------------------------
# ----------------------------------- ATAQUE -----------------------------------
# ------------------------------------------------------------------------------
func melee_entered(body: Node3D) -> void:
	if not attacking and body.name in ["Player", "Safe"]:
		attack(body)

func animation_finished(anim_name: StringName) -> void:
	if anim_name == "Ataque":
		attacking = false

func attack(body: Node3D):
	attacking = true
	animation.play("Ataque")
	
	# Animation speed changes based on state
	animation.speed_scale = atk_speed if not enraged else ex_atk_speed
	await get_tree().create_timer(1.2 / animation.speed_scale).timeout
	
	# Play sound only at mid-swing
	sounds.get_node("Axe").pitch_scale = randf_range(0.8,1.2)
	sounds.get_node("Axe").play()
	
	# Damage before axe reaches the floor (before end of animation)
	if body in damage_range.get_overlapping_bodies():
		body.take_damage(damage if not enraged else ex_damage)
		
# ------------------------------------------------------------------------------
# ------------------------------------ VIDA ------------------------------------
# ------------------------------------------------------------------------------
func take_damage(n: int):
	health -= n
	if health <= 0:
		Global.fish_kills += 1
		queue_free()
