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
const type = "shrimp"

# ------------------------------------------------------------------------------
# ----------------------------- FUNCIONES NORMALES -----------------------------
# ------------------------------------------------------------------------------
func _ready():
	super._ready()
	# Parámetros normales
	health = 5
	damage = 3
	speed = 1
	
	# Parámetros para el estado enfurecido
	ex_speed = 1.5
	ex_damage = 5
	ex_atk_speed = 1.75

func _physics_process(_delta: float) -> void:
	# Do not move while attacking
	if attacking or not target:
		return

	# Look at target
	nav.target_position = target.global_position
	look_at(nav.target_position)
	
	# Spam attack if in range
	if target in attack_range.get_overlapping_bodies():
		attack(target)
	
	# Walk to target with pathfinding
	else:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		direction.y = 0
		velocity = direction * (speed if not enraged else ex_speed)
		animation.play("Walking")
		move_and_slide()


# ------------------------------------------------------------------------------
# ----------------------------------- ATAQUE -----------------------------------
# ------------------------------------------------------------------------------
func melee_entered(body: Node3D) -> void:
	if not attacking and body.name in ["Player", "Safe"]:
		attack(body)

func animation_finished(anim_name: StringName) -> void:
	if not target:
		return

	if anim_name == "Attack":
		attacking = false

func attack(body: Node3D):
	if not target:
		return

	attacking = true
	animation.play("Attack")
	
	# Animation speed changes based on state
	animation.speed_scale = atk_speed if not enraged else ex_atk_speed
	await get_tree().create_timer(1.66 / animation.speed_scale).timeout
	
	# Play sound only at mid-swing
	sounds.get_node("Axe").pitch_scale = randf_range(0.8,1.2)
	sounds.get_node("Axe").play()
	
	# Damage before axe reaches the floor (before end of animation)
	if body in damage_range.get_overlapping_bodies():
		body.take_damage(damage if not enraged else ex_damage)
		
# ------------------------------------------------------------------------------
# --------------------------------- DETECCION ----------------------------------
# ------------------------------------------------------------------------------
func detection_entered(body: Node3D) -> void:
	if not target:
		return

	if body.name == "Player":
		target = body

func detection_exited(body: Node3D) -> void:
	if not target:
		return

	if not enraged and body.name == target.name:
		target = safe

# ------------------------------------------------------------------------------
# ------------------------------------ VIDA ------------------------------------
# ------------------------------------------------------------------------------
func take_damage(n: int):
	if not target:
		return

	health -= n
	animation.play("Damaged")
	sounds.get_node("Damaged").play()
	if health <= 0:
		Global.shrimp_kills += 1
		queue_free()
