extends CharacterBody3D

var speed = 0
const WALK_SPEED = 5
const SPRINT_SPEED = 8
const JUMP_VELOCITY = 5
const SENSITIVITY = 0.03

const BOB_FREQ = 2 
const BOB_AMP = 0.06
var t_bob = 0

@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D
@onready var armature: Node3D = $Armature
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		armature.rotate_y(-event.relative.x * SENSITIVITY)
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
func _physics_process(delta: float) -> void:
	# Handle jumping and gravity
	var sprinting = Input.is_action_pressed("sprint")
	var floor_ = is_on_floor()
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not floor_:
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	if direction:
		animation.play("Walking")
		velocity.x = direction.x * (SPRINT_SPEED if sprinting else WALK_SPEED)
		velocity.z = direction.z * (SPRINT_SPEED if sprinting else WALK_SPEED)
	else:
		velocity.x = 0
		velocity.z = 0
	
	if Input.is_action_just_pressed("lclick"):
		animation.play("Attack")
		
	t_bob += delta * velocity.length() * float(floor_)
	camera.transform.origin = Vector3(cos(t_bob * BOB_FREQ / 2) * BOB_AMP, sin(t_bob*BOB_FREQ) * BOB_AMP, 0)
	
	move_and_slide()

	
