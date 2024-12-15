extends PathFinderEnemy

@onready var nav: NavigationAgent3D = $Navigation
@onready var safe: Node3D = %safe

func _ready():
	super._ready()
	health = 5
	speed = 3
	exalted_speed = 5.5
	attack_damage = 3
	attack_speed = 1.0


func _physics_process(delta: float) -> void:
	nav.target_position = target.global_position
	
	var direction = (nav.get_next_path_position() - global_position).normalized()
	direction.y = 0
	velocity = velocity.lerp(direction, delta)
	
	move_and_slide()
