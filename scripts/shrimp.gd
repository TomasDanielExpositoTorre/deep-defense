extends PathFinderEnemy

@onready var nav: NavigationAgent3D = $Navigation
@onready var safe: Node3D = %Safe
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var damage_range: Area3D = $DamageRange
@onready var attack_range: Area3D = $AttackRange

# ------------------------------------------------------------------------------
# ----------------------------- FUNCIONES NORMALES -----------------------------
# ------------------------------------------------------------------------------
func _ready():
	super._ready()
	# Parámetros normales
	health = 5
	damage = 3
	speed = 1
	
	# Parámetros para el estado "exaltado"
	ex_speed = 2
	ex_damage = 7
	ex_atk_speed = 2

func _physics_process(delta: float) -> void:
	nav.target_position = target.global_position
	
	# Moverse al target cuando no ataca
	if not attacking:
		look_at(nav.target_position)
		animation.play("Walking")
		
		var direction = (nav.get_next_path_position() - global_position).normalized()
		direction.y = 0
		
		velocity = direction * (speed if not exalted else ex_speed)
	
		move_and_slide()


# ------------------------------------------------------------------------------
# ----------------------------------- ATAQUE -----------------------------------
# ------------------------------------------------------------------------------
func melee_entered(body: Node3D) -> void:
	if body.name in ["Player", "Safe"]:
		attacking = true
		attack(body)
			
func animation_finished(anim_name: StringName) -> void:
	if target in attack_range.get_overlapping_bodies():
		look_at(target.global_position)
		attack(target)
	elif anim_name == "Attack":
		attacking = false

func attack(body: Node3D):
	animation.play("Attack")
	animation.speed_scale = atk_speed if not exalted else ex_atk_speed
	await get_tree().create_timer(1.66 / animation.speed_scale).timeout
	
	if body in damage_range.get_overlapping_bodies() and body.has_method("take_damage"):
		body.take_damage(damage if not exalted else ex_damage)

# ------------------------------------------------------------------------------
# --------------------------------- DETECCION ----------------------------------
# ------------------------------------------------------------------------------
func detection_entered(body: Node3D) -> void:
	if body.name == "Player":
		target = body

func detection_exited(body: Node3D) -> void:
	if body.name == target.name and not exalted:
		target = safe

# ------------------------------------------------------------------------------
# ------------------------------------ VIDA ------------------------------------
# ------------------------------------------------------------------------------
func take_damage(n: int):
	health -= n
	if health <= 0:
		queue_free()
